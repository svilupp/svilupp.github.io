@def title = "Business Case for Julia Adoption"
<!-- @def published = "27 July 2023" -->
@def drafted = "27 July 2023"
@def tags = ["julia","business"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
Adopting the Julia programming language for your projects can potentially cut your project completion times in half. The following sections provide several examples of how the reduction can be achieved across the different stages of the project lifecycle. This post should serve as a scaffold and reference to help you build the business case for Julia adoption in your organization.

\toc

# Introduction
At the recent JuliaCon 2023, I had the opportunity to share my thoughts ([link](https://www.youtube.com/watch?v=yJE3FYpHe18)) on why Julia is a game-changer in the world of data science and business decision intelligence.

My presentation was centered around three core tenets - Learn Faster, Build Faster, and Build Better - which encapsulate the potential of Julia to revolutionize the way we help businesses make data-driven decisions.

This blog provides several examples of how the efficiencies are achieved.

There are three key sections: 
1) Introduction to CRISP-DM as the reference project lifecycle framework
2) Summary table with the pre- and post durations
3) Examples and comments for each phase.

## Adapt me!
Each business is different.

I'm using estimates based on my personal experience and projects. Whilst your baselines should be different, I believe that you should be able to achieve broadly the same relative benefits (ie, halving the completion time). Use the examples and their relevance to adapt it to your case.

You can increase the odds of success by following the advice provided in my talk.

# CRISP-DM

Before we delve into the advantages of Julia, let's briefly discuss the Cross-Industry Standard Process for Data Mining (CRISP-DM). Introduced in 1999, CRISP-DM has emerged as a widely accepted methodology for data mining, analytics, and data science projects.

![CRISP-DM Framework](/assets/business_case_for_julia_adoption/CRISP-DM.png)

CRISP-DM is structured around six sequential phases:

- **Business Understanding:** This phase involves understanding the business need. It helps define the problem and determine the project objectives from a business perspective.
- **Data Understanding:** This phase is all about data exploration. It includes understanding what data is available, whether it's clean or requires cleansing, and determining if additional data is needed.
- **Data Preparation:** This phase involves organizing the data for modeling. It usually includes activities like data cleaning, transformation, and feature engineering.
- **Modeling:** This phase involves applying appropriate data modeling techniques to the prepared data. It includes the selection of potential models, their training, and tuning.
- **Evaluation:** This phase involves assessing the models against the business objectives defined in the first phase. It helps decide which model best meets the business objectives.
- **Deployment:** The final phase involves deploying the chosen model into a business environment. It includes making the results accessible to stakeholders and integrating the model with business processes for actionable insights.

The CRISP-DM process is cyclical, requiring a return to earlier stages as new insights or issues are uncovered. This iterative approach ensures more refined and impactful outcomes over time. In the following sections, we will explore how Julia can enhance each phase of this process.

# Summary Table

| Phase                 | Timeline     | Power-Ups                                            |
|:-----------------------|:--------------|:---------------------------------------------------|
| Business understanding | -        | Quarto+Literate.jl                                 |
| Data understanding     | 2W -> 1W | Julia+VSCode, ClipData.jl, Pluto.jl           |
| Data preparation       | 4W -> 2W | DataFramesMeta.jl, re-usability, types+multiple dispatch |
| Modeling               | 2W | MLJ.jl, Flux.jl, Turing.jl, SymbolicRegression.jl                   |
| Evaluation (+Application) | 4W -> 2W | SHAP.jl, JuMP.jl, Optim.jl, Stipple.jl       |
| Deployment             | 8W -> 3W | Pkg.jl, Test.jl, Profiler in VSCode  |
| **Total**                 | 20W -> 10W |   -                                           |

Note: The largest source of benefits is the reusability and easy reproducibility, which generate efficiencies only in subsequent projects, i.e., expect to see their benefits in the second or third project.

# The Examples and Comments

## Business Understanding

- Time Reduction: NaN (continuous)

### Ex1: Seamless communication with stakeholders
`Literate.jl` and Quarto allow you to write technical documents in Julia with live code, text, visualizations and anything else you might need. Key feature is that you define the content and the formatting is done automatically allowing you to focus on what matters. 

You can generate beautiful reports and presentations in many formats, all with a single command, e.g., my talk was generated in Quarto as well and all animations were done automatically.

Since the information is saved as plain text, it can be version-controlled and stored in your project repository to ensure it's kept up-to-date.
 
## Data Understanding

- Time Reduction: From 2 weeks to 1 week

### Ex1: Rapid iteration of data exploration
In the early phases of a project, you often receive snippets and examples of data in various formats. With `ClipData.jl` you can quickly copy and paste data straight from (/to) your clipboard and explore any dataset immediately. This reduces the number of iterations necessary to establish the data sources needed (and their fields).

VS Code has several very nice preview facilities for tabular data (eg, `vscodedisplay()`, but there is also `TerminalPager.jl` and `TabularDisplay.jl`) allowing you to quickly preview the data and iterate over it, without having to switch to another application.

### Ex2: Interactive data exploration made easy
For data manipulations, `@chain` macro in `DataFramesMeta.jl` provides a way to define several subsequent data transformations (eg, select, filter, aggregate) in a pipeline with each step on a new row. This saves typing (and prevents creating unnecessary intermediate variables) and allows one to comment/uncomment individual steps to explore different aspects of the data quickly and easily.

For quick visualizations, `StatsPlots.jl` offers a convenience macro `@df` that makes plotting easy with any tabular dataset. These plots can be easily added as a the last step of the `@chain` data pipeline.

`Pluto.jl` notebooks provide a seamless way to build a fully reactive notebook ("dashboard") allowing you to explore various aspects of the dataset "live" with your subject matter experts. Full reactivity means that any change in the controllers is immediately reflected in the output of all(!) relevant cells.

All together, in a few key strokes you can investigate all aspects of your dataset. With a few quick plots, you can stitch together an interactive dashboard with fully reactive controls (eg, add a drop-down to slide data by specific sub-groups or features) to significantly reduce the time needed to reverse-engineer the data generating process with your SMEs.

## Data Preparation

- Time Reduction: From 4 weeks to 2 weeks

### Ex1: Data sourcing developed only once
Each business segment has their common data sources and data capture logic, with Julia you would abstract using them into lightweight "packages" (self-standing code with associated tests) to be re-used in the future. E.g., build a simple package to download parametrized SQLs (with the SQL templates saved as separate files) embedding the necessary connection and processing details to cut down your future data discovery and acquisition times. 

Julia's multiple dispatch allows building elegant and simple interfaces to your data sources, so users don't need to learn any new syntax.

### Ex2: Share your work effortlessly
Any re-usable package should be registered in your internal local registry (`LocalRegistry.jl`). It will allow any team member to easily access the latest version of each packages with Julia built-in package manager (no more copy&pasting). Being able to obtain the right version (including the past ones) on demand is key for future reproducibility!

### Ex3: Re-use the data pipelines
The `@chain` pipelines you built in the data understanding become the foundation of your codebase. You simply need to wrap them in a function, add some validation, documentation, logging and error handling and you have a robust data pipeline. All of which can be done by simply extending the `@chain` pipeline with a few extra lines (see `@assert` macro).

## Modeling

- Time Reduction: Stays ~2 weeks

There are several benefits Julia offers, but I would argue that they don't drastically reduce the time required, because Scikit-Learn ecosystem is very powerful as well.

### Ex1: Learn new methods and approaches easily
Julia's multiple dispatch significantly reduces the amount of syntax one has to learn. Whether it's a Bayesian Inference in `Turing.jl` or neural networks in `Flux.jl`, you'll be using the same syntax and the same packages you know from elsewhere, allowing you to learn new domains faster.

### Ex2: Experiment with many model types
Similarly to Scikit-Learn in Python, Julia has a metapackage `MLJ.jl` that provides a uniform interface to many different model classes and modelling methods (including evaluation, tuning, stacking, building learning networks, etc.). This allows you to easily experiment with many different models and compare their performance. 

The clear advantage is that it can leverage the data types to guide the user to applicable models and prevent subtle bugs.

### Ex3: Discover powerful features
One of the most exciting developments in the Scientific Machine Learning (SciML) has been the development of `SymbolicRegressions.jl` package. It allows you to discover explainable yet powerful relationships in your data set!

## Evaluation/Applications

- Time Reduction: From 4 weeks to 2 weeks

### Ex1: Explain your models
We always need to check that our models don't have any inherent biases. `SHAP.jl` allows you to unwrap any black-box model and explain the predictions in a way that is easy to communicate to your stakeholders. 

If you need more intuitive explanations, you should use `CounterfactualExplanations.jl`, which avoids the need for proxy model and provides explanations that anyone can understand.

### Ex2: Translate model outputs into optimal actions
Decision intelligence is a new field that combines the power of machine learning with the power of optimization. You take the model outputs and given the structure of your problem, you use `Optim.jl` or `JuMP.jl` to find the best actions that should be taken. 

`Jump.jl` is the easiest way to tackle linear integration optimization problems that you've ever seen!

### Ex3: Build interactive web apps
Offline evaluation can take you only so far. You need to test your models in the real world. `Stipple.jl` allows you to build interactive web apps with a few macros that can be used to test your work with your end-users.

The fact that everything is in Julia means that there is very little extra code that needs to be added leading to fast development cycle.

`Stipple.jl` is built on top of the stellar `Genie.jl` allowing you to add databases, authentication, build the UI with the low-code builder in VS Code and much more!

## Deployment

- Time Reduction: From 8 weeks to 3 weeks

### Ex1: Change very little code
It's a standard for all Julia code to be automatically packaged, tested and documented through out the development, which means that there is very little change required. Usually, most of effort goes into improving the documentation.

### Ex2: Share and reproduce easily
Julia has best-in-class package manager (`Pkg.jl`) allowing you to perfectly replicate any environment. 

It also has a built in testing framework (`Test.jl`), which means that it's easier for everyone to embrace the testing mindset.

With `LocalRegistry.jl` all your internal packages are one `add` call away.

### Ex3: Optimize performance
Julia's performance is already very good out of the box. However, if you need to optimize it, you can use the built-in profiler in VS Code to quickly identify bottlenecks. 

With Julia's type stability tooling (`@code_warntype`) and benchmarking suite (`BenchmarkTools.jl`) you can quickly find the optimal solutions.

If you need more performance, there are tonnes of package allowing you to get C-level speeds, removing allocations, using GPUs, IPUs, MPIs, anything your application might require!

# But I can do this in Python too?

I know. But in business, we care a lot about efficiency and Julia provides unbeatable "time-to-results" (= time-to-learn + time-to-build + time-to-run + time-to-share or -apply).

# Conclusion

In conclusion, the adoption of Julia in your data science workflow presents a substantial opportunity to reduce project completion time, improve understanding, and deliver more effective results. Although the learning curve may seem steep initially, the long-term benefits are unquestionable, as demonstrated in this blog post. 

In sum, adopting Julia can lead to a potential reduction in the project completion time from 20 weeks to just 10 weeks. Every stage of the CRISP-DM process reaps the benefits of Julia's flexibility, efficiency, and interoperability.

By investing the time to learn Julia, you're not just adding another tool to your data science toolkit, but you're embarking on a journey that will redefine your data science practices for the better. So give Julia a shot, and let it empower you to learn faster, build faster, and build better solutions for your business!