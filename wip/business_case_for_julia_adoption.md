@def title = "Business Case for Julia Adoption"
<!-- @def published = "27 July 2023" -->
@def drafted = "27 July 2023"
@def tags = ["julia","business"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
Adopting the Julia programming language for your projects can potentially cut your project completion times in half. The following sections provide several examples of how the reduction can be achieved across the different stages of the project lifecycle.

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
Each business is different. Hopefully, the examples will help you think about where the benefits would come from and adjust it for your case when presenting it to the management.

Note that I'm using estimates based on my personal experience and projects. Whilst your baselines should be different, I believe that you should be able to achieve broadly the same relative benefits (ie, halving the completion time). 

Increase the odds of success by following the advice provided in my talk.

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
|-----------------------|--------------|------------------------------------------------------|
| Business understanding | -        | Quarto+Literate.jl                                 |
| Data understanding     | 2W -> 1W | Julia+VSCode, ClipData, re-use prev. work           |
| Data preparation       | 4W -> 2W | DataFramesMeta.jl, re-usability, types+multiple dispatch |
| Modeling               | 2W | MLJ.jl, Flux.jl, Turing.jl, SymbolicRegression.jl                   |
| Evaluation (+Application) | 4W -> 2W | SHAP.jl, JuMP.jl, Optim.jl, Stipple.jl              |
| Deployment             | 8W -> 3W | Pkg.jl+Test.jl, Profiler in VSCode  |
| **Total**                 | 20W -> 10W | -                                                    |

Note: The largest source of benefits is the reusability and easy reproducibility, which generate efficiencies only in subsequent projects, i.e., expect to see their benefits in the second or third project.


# The Examples and Comments

## Business Understanding

- Time Reduction: NaN (continuous)

### Ex1: Seamless communication with stakeholders
`Literate.jl` and Quarto allow you to write technical documents in Julia with live code, text, visualizations and anything else you might need. 
You can generate beautiful reports and presentations all at once with a single command, significantly reducing the preparation time and giving your team more time for other work.
Since the information is saved as plain text, it can be version-controlled and stored in your project repository to ensure it's kept up-to-date.
 
## Data Understanding

- Time Reduction: From 2 weeks to 1 week
- Notes: ClipData for rapid iteration of data between VSCode and any other source (Database clients, emails, Teams messages, ...), VS Code Julia Extensions + `vscodedisplay()`, StatsPlots.jl and DataFrameMeta.jl macros for EDA

### Ex1: Rapid iteration of data exploration
In the early phases of a project, you often receive snippets and examples of data in various formats. With `ClipData.jl` you can quickly copy and paste data straight from (/to) your clipboard and explore any dataset immediately. This reduces the number of iterations necessary to establish the data sources needed.

VS Code has several very nice preview facilities for tabular data (eg, `vscodedisplay()` or even `TerminalPager.jl`). This allows you to quickly preview the data and iterate over it, without having to switch to another application.

### Ex2: Interactive data exploration made easy
`Pluto.jl` notebooks provide a seamless way to build a fully reactive notebook ("dashboard") on the fly allowing you to explore various aspects of the dataset together with your subject matter experts. Full reactivity means that any change in the controllers is immediately reflected in the output of all(!) relevant cells.

## Data Preparation

- Time Reduction: From 4 weeks to 2 weeks
- Notes: DataFramesMeta.jl macros for data transformation, re-use previous work (eg, previous pipelines that are tested), types+multiple dispatch

Data Preparation is the stage where we cleanse, transform, and organize data for modeling. With Julia's package `DataFramesMeta.jl`, we can leverage macros to craft cleaner and more efficient data transformations. Take the example of joining multiple data sources or creating new derived features, `@chain` macro in `DataFramesMeta.jl` allows for easier-to-read and performant data manipulation. Coupled with Julia's emphasis on code reusability and multiple dispatch, the bespoke code we write in this phase can be repurposed in subsequent stages or future projects, significantly reducing the timeline.


## Modeling

- Time Reduction: NaN
- Notes: From the simple to deep networks, all very easy and integrated to the rest of code. SymbolicRegressions.jl is amazing for discovery (and feature generation). The simplest linear regression doesn't even require any extra package - it's built-in in Julia! Julia is built around arrays!

During the Modeling phase, we deploy various modeling techniques on our prepared data. Leveraging Julia packages such as `MLJ.jl` for machine learning, `Flux.jl` for deep learning, and `Turing.jl` for Bayesian inference, we can construct versatile and potent models. A practical example is using `MLJ.jl` which provides a uniform interface for calling models from various other packages. Although the timeline for this phase might remain the same, the enhanced comprehension and seamless environment that Julia offers will undoubtedly lead to better model development.


## Evaluation/Applications

- Time Reduction: From 4 weeks to 2 weeks
- Notes: Find out how to translate model outputs into optimal actions with Optim.jl and JuMP.jl, build interactive web apps with Stipple.jl - both to communicate the logic but also to run the experience with end-users, unwrap any black-box model with SHAP.jl

The Evaluation phase entails determining which of our models best align with business objectives. Julia's extensive ecosystem, boasting packages like `SHAP.jl` for model interpretability, `JuMP.jl` for optimization, and `Stipple.jl` for creating interactive web apps, turns the evaluation phase into a smoother process. For example, using `SHAP.jl`, we can better understand (non-linear! pointwise!) feature effects in complex models and effectively communicate them to stakeholders. The power of these tools can lead to a reduction in the timeline from 4 weeks to just 2.

## Optimizing Deployment with Julia

- Time Reduction: From 8 weeks to 3 weeks
- Notes: Very little code to change! Tests built up as the project is built and all is automatically ran in CI on every push to the code repository. Pkg.jl allows easy reproducibility. VSCode Profiler quickly highlights bottlenecks, but performance rarely requires any attention - it's more than sufficient out of the box.

The final phase, Deployment, involves making our models available to stakeholders. With Julia's `Pkg.jl` and `Test.jl` for package management and testing, and the Profiler in VSCode for identifying bottlenecks, we can optimize this phase from 8 weeks to just 3. For instance, using `Pkg.jl` we can effectively manage dependencies, create reproducible environments, and ensure that our models run reliably when deployed.

In sum, adopting Julia can lead to a potential reduction in the project completion time from 20 weeks to just 10 weeks. Every stage of the CRISP-DM process reaps the benefits of Julia's flexibility, efficiency, and interoperability. Embracing Julia in your data science projects can significantly accelerate delivery timelines and produce impactful results faster.

# Conclusion

In conclusion, the adoption of Julia in your data science workflow presents a substantial opportunity to reduce project completion time, improve understanding, and deliver more effective results. Although the learning curve may seem steep initially, the long-term benefits are unquestionable, as demonstrated in this blog post. By investing the time to learn Julia, you're not just adding another tool to your data science toolkit, but you're embarking on a journey that will redefine your data science practices for the better. So give Julia a shot, and let it empower you to learn faster, build faster, and build better!