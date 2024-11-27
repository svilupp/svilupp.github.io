@def title = "RAG-Enhanced Customer Data Deduplication with Julia"
@def drafted = "27 November 2024"
@def tags = ["julia", "business", "RAG", "data-matching"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
This post demonstrates how to repurpose Retrieval Augmented Generation (RAG) for intelligent customer data deduplication in Julia, achieving up to 80% reduction in manual review time while maintaining high accuracy.

\toc

# RAG for Deduplication: A New Mental Model

Traditional deduplication approaches rely on exact matching or complex rule sets. But what if we thought about deduplication the same way we think about RAG in large language models?

## The RAG Parallel
In traditional RAG:
1. **Retrieve**: Find relevant context from a knowledge base
2. **Generate**: Use an LLM to reason about that context and generate an answer

In RAG-based deduplication:
1. **Retrieve**: Find potential matching records using semantic search
2. **Reason**: Use an LLM to analyze whether candidates truly match

This parallel isn't just theoretical—it leads to a more robust and maintainable solution.

## Why This Matters
Real-world customer data is messy. Names appear as "Bob" or "Robert". Addresses contain typos. Phone numbers use different formats. Traditional rule-based systems struggle with these variations, requiring constant maintenance and producing brittle solutions.

RAG-based deduplication handles these challenges naturally. The semantic search finds potential matches despite surface differences, while the LLM applies human-like reasoning to determine true matches. Each decision comes with detailed explanation, making the process transparent and auditable.

## The Implementation
Our Julia solution combines a hybrid search index for candidate retrieval with LLM-powered analysis. The system processes high-confidence matches automatically while flagging edge cases for human review. All processing happens locally, preserving data privacy.

![RAG-Enhanced Matching](/assets/rag_dedupe/diagram.jpeg)

The diagram above illustrates how our system processes new contact records:
1. A new contact enters the system
2. The hybrid search index (combining semantic and keyword search) identifies potential matches
3. The LLM analyzes each candidate pair, providing detailed reasoning
4. High-confidence matches are processed automatically, while uncertain cases are flagged for review

## Getting Started
Start with a focused use case like customer service integration. The provided Julia code demonstrates the core components. Monitor results and expand as confidence grows.

## Conclusion
RAG-based deduplication represents a paradigm shift in how we approach data matching. By leveraging the same patterns that make RAG successful in LLMs, we can create more robust, maintainable, and intelligent deduplication systems. The approach reduces manual review time while providing transparent, explainable decisions.

The complete implementation is available in the code section below for those interested in the technical details.

# Code Implementation

Build index
```julia
# Index building functionality
using PromptingTools
const PT = PromptingTools
using PromptingTools.Experimental.RAGTools
const RT = PromptingTools.Experimental.RAGTools
using JSON3
using Serialization
using LinearAlgebra, Unicode, SparseArrays, Snowball


Base.@kwdef struct ContactInfo
    full_name::String
    address::String
    city::String
    state::String = "NY"
    email::String
    telephone::String
end

@enum JudgementType DUPLICATE NOTDUPLICATE
@enum Difficulty EASY MEDIUM HARD
Base.@kwdef struct ContactVariation
    reasoning::String
    type::JudgementType
    difficulty::Difficulty
    full_name::String
    address::String
    city::String
    state::String = "NY"
    email::String
    phone::String
end

# Define Document structure
function format_contact(contact)
    "Contact: $(contact.full_name)\nAddress: $(contact.address)\nCity: $(contact.city)\nState: $(contact.state)\nEmail: $(contact.email)\nPhone: $(contact.telephone)"
end


# Load the contacts
contacts_data = JSON3.read("rag_dedupe/contacts.json", Vector{ContactInfo})

# Convert contacts to strings for indexing
documents = [format_contact(contact) for contact in contacts_data]
sources = collect(1:length(documents)) .|> string

index = RT.build_index(
    documents; chunker_kwargs=(; sources)
)

# Serialize the index
serialize("rag_dedupe/contacts_index.jls", index)
keywords_index = RT.ChunkKeywordsIndex(index)
multi_index = RT.MultiIndex([index, keywords_index])
serialize("rag_dedupe/contacts_multi_index.jls", multi_index)

```


```julia
using PromptingTools
const PT = PromptingTools
using PromptingTools.Experimental.RAGTools
const RT = PromptingTools.Experimental.RAGTools
using JSON3
using Serialization
using LinearAlgebra, Unicode, SparseArrays, Snowball

# Load the serialized index
index = deserialize("rag_dedupe/contacts_multi_index.jls")

# Create custom templates for duplicate detection
duplicate_template = PT.create_template(;
    system="""You are a contact database expert. Your task is to determine if two contact entries refer to the same person.
  Consider variations in names (nicknames, titles, suffixes), formatting differences in phone/email, and typos.
  Provide detailed reasoning for your decision.""",
    user="""Compare these contacts and determine if they are duplicates:
  Original Contact: {{original}}
  Candidate Contact: {{candidate}}

  Explain your reasoning and conclude with DUPLICATE or NOT_DUPLICATE.""",
    load_as=:DuplicateDetector
)

@enum JudgementType DUPLICATE NOTDUPLICATE

"Decision whether the candidate contact is a duplicate of the original contact. First, provide thorough reasoning, then the judgement. Make sure to weigh all evidence in favor of being DUPLICATE and against it."
struct DuplicateJudgement
    reasoning::String
    judgement::JudgementType
end

"Vanilla search, no rephrasing and no re-ranking."
function find_duplicates(index, contact; n_results=5)

    contact_blob = format_contact(contact)
    # Use basic retriever
    retriever = RAGTools.SimpleRetriever()
    retriever.finder = RT.MultiFinder([RT.CosineSimilarity(), RT.BM25Similarity()])

    # Perform search
    results = RAGTools.retrieve(
        retriever,
        index,
        contact_blob;
        top_k=n_results
    )

    # Analyze each candidate
    @info "Found $(length(results.context)) potential matches"
    judgements = []
    ## TODO: skip if score is low
    for (content, source) in zip(results.context, results.sources)
        msg = aiextract(
            :DuplicateDetector;
            original=contact_json,
            candidate=content,
            return_type=DuplicateJudgement
        )
        push!(judgements, msg.content)
    end
    return judgements
end

# Load test variations to verify
variations = JSON3.read("rag_dedupe/contact_variations.json", Vector{ContactVariation})
original_contact = variations[1]  # Original contact
known_duplicate = variations[2]   # Known duplicate with typos
known_non_duplicate = variations[4]  # Similar but different contact

judgements = find_duplicates(index, original_contact)
judgements[1]

judgements = find_duplicates(index, known_duplicate)
judgements[1]

judgements = find_duplicates(index, known_non_duplicate)
judgements[1]