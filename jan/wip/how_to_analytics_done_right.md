@def title = "Set up Privacy-conscious Analytics in 20 Minutes"
<!-- @def published = "20 August 2022" -->
@def tags = ["housekeeping","privacy"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
Privacy policy is legally required for majority of websites. If you want an effortless option, consider Plausible.io for 90 eur/month. Best free option I found is Termly + Google Tag Manager + Google Analytics.

# Motivation
As an improvement-obsessed person, when I set up my personal blog ([here](https://simlj.earth), effortless thanks to [Franklin.jl](https://franklinjl.org/)) my first thought was “how will I measure the traffic to keep getting better?"

While Google analytics is an easy choice for tracking, it is no longer sufficient on its own. It is legally required in many countries to have a privacy policy AND to obtain user’s consent before you start tracking (in most cases).

This blog post is a summary of my research and a brief how to guide to help you set up privacy-conscious (and compliant) website analytics for free in 20 minutes.

# Does it concern my website?
Oversimplifying here a bit but if you use any of cookies, IP addresses (location), browser or device information or any standard analytics solution (Google analytics, Matomo, etc) you need to read on.

The reason is that if an EU citizen visits your website, you are liable to EU's [General Data Protection Regulation (GDPR)](https://gdpr.eu/what-is-gdpr/). That means you need to follow specific rules for:
- what information you need to provide
- what form and type of consent you require
- what you can and cannot track (eg, IP address is considered to be a Personal Identifiable Information (PII))
- how you need to process, transfer the information
- and much more...

The similar holds for other privacy regulations around the world (eg, [UK's GDPR](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/), [Canadian PIPEDA](https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/pipeda_brief/), [Californian CCPA](https://www.csoonline.com/article/3292578/california-consumer-privacy-act-what-you-need-to-know-to-be-compliant.html))

Practically, you should also publish Terms and Conditions for your website (even if it's a persoanl website), but that's a separate topic!

Now that we have established the need, let’s look into what we need to do.

# So what do I need to do?
You can read about it in detail [here](https://www.termsfeed.com/blog/sample-blog-privacy-policy-template/) or from a more authoritative source [here](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/the-right-to-be-informed/what-privacy-information-should-we-provide/).

In short, we need to:
- collect, transfer and store the minimum information possible (in most cases your personal blog requires little or no Personal Identifiable Information (PII)) in a safe and compliant way (best to leave it to specialists)
- request user's consent before any tracking starts (eg, before any cookies or PII is collected) and ensure it's an explicit opt-in (ie, an implicit consent if the user ignores the pop up is not sufficient!)
- create a Privacy and Cookie Policy for your website that describe what you track, how and why

# Solution Comparison
TODO: Add more detail for each

### Gold Solution: Plausible.io

### Silver Solution: Google + Termly <-- My Choice

### Bronze Solution: Google + Osano + Termsfeed

# Deep dive on the winning solution
The winning solution for me was #2. It requires slightly more effort to set up, but it’s free (great for personal or open source projects!) and has more powerful analytics features for the future.
- Tracking: GoogleAnalytics version GA4
> Side note: Why GA4 and not Universal Analytics (UA)?
>
> No one should start a new analytics account with UA in 2022, as it will be sunset in July 2023. Moreover, GA4 has been built with modern considerations and experiences in mind (eg, mobile devices, privacy-conscious consumers). This tutorial does not take advantage of its full power but it gives you extensible option for the future (eg, estimated traffic if everyone consented to tracking)

- Consent Management: Termly.io
- Privacy Policy and Cookie Policy generation: Termly.io
- Orchestration: Google Tag Manager

# Setting up our solution
TODO: Add screenshots and more detail

### 1) Set up GA4
- Create an account [here](https://analytics.google.com/)
- Set up a Property for measurements (Bottom left - Admin - Create Account - Create Property)
- TODO: finish with a screenshot
- Click on xyz to get to measurement ID <- Save this for later, we will need it to set up the Google Tag Manager

I’d highly recommended changing some of the default settings to capture only what is strictly necessary and retain data (and cookies) for as short time as possible.
The letter of law might have many interpretations here but your visitors will certainly appreciate it!

### 2) Set up Termly [10 mins]
- Sign up for a Basic plan [here](https://app.termly.io/user/sign-up)
- Enter some basic details for your website (enter the name, address, etc)
    - You should see your dashboard now!
- Scan your cookies (which will also create your Cookie Policy)
- Generate Privacy Policy by going through the guide (important: provide accurate information!)
- Download the Google Tag Manager configuration .json file from [here](https://app.termly.io/Termly_GDPR_GTM_Solution.json) (source: [Termly support article](https://help.termly.io/support/solutions/articles/69000108888-blocking-javascript-third-party-cookies-with-google-tag-manager) )
- Save Privacy and Cookie policies into separate HTML files
    - On the dashboard, click on Embed
    - Select the HTML options
    - Copy the HTML code
    - Open a text editor, paste it in and save as privacy_policy.html and cookie_policy.html, respectively

### 3) Set up Google Tag Manager (GTM)
- Create a Google Tag Manager account for your website with your Google account if you do not have one ([link](https://tagmanager.google.com)) - let's call it "MyWebsite"
- In your default workspace, Go to Admin - Import Container and select the .json file we downloaded from Termly in the previous step
- Choose to merge with your existing setting
- Confirm it - You should see several new "tags" and "triggers" created
- Let's set up Termly consent banner
    - You should see Tag named "Initialization", open it
    - Copy & paste the code from Termly TODO: add snippet
    - Replace the Web ID Code
    - TO DO: add screenshot
    - Set priority to 10 (to make sure it has priority)
- Configure up Google Analytics GA4
    - Click New - GA4 configuration
    - Select the events you want to track
    - Make sure to select trigger "Unblock Analytics Cookies" to ensure GA4 will start only once the user has consented to its
- Submit the new GTM configuration (top right corner)! Without submitting the new version, it won't be deployed and it won't take effect.

A more detailed guide can be found [here](https://help.termly.io/support/solutions/articles/69000108888-blocking-javascript-third-party-cookies-with-google-tag-manager)


### 4) Update your website
- Put your tag manager code in the header of each page (right after <head> tag)
- Upload the respective html files to your website
- Ideally, add links to your privacy policy in the footer on each page

If you use Franklin.jl to produce your website, you can find some additional tips in Appendix.

### 5) Test that it worked
- go to your website, a banner should appear
- Open the Inspector (Chrome …) and go to tab Application
- You should not see any ga cookies
- Click on Allow in the Consent Banner and you should see 2 GA cookies (name "_ga*") appear

# Appendix

## Tips for integrating into Franklin.jl websites
- update the pages to have headers and footers, update navbar, where to put the google tag manager

## How to reduce Google cookie expiration

To see the Google support article go [here](https://support.google.com/analytics/answer/11397207?hl=en). The step that was hard for me was that you need to expand the options via "Show All" to see "Override Cookie Settings"

- Go to your Google Tag Manager account
- Open your Admin console ("Admin" on the bottom left) and select the Property for your website
- Open Data Settings - Data Streams and select your strema (your website)
- Click on Configure Tag Settings (at the bottom)
- And Expand all settings options via "Show All" on the right-hand side
- Select Override Cookie Settings - Edit - Set Cookie expiration to 1 month
- Click "Save" for changes to take effect

[![Changing GA cookie expiration](asserts/how_to_analytics_done_right/ga_change_cookie_expiration.png)]

## How to reduce Google's data retention
- Go to your Google Analytics account
- Open your Admin console ("Admin" on the bottom left) and select the Property for your website
- Open Data Settings - Data retention
- Change "Event Data Retention" to 2 months
- Click "Save" for changes to take effect

[![Changing GA data retention](asserts/how_to_analytics_done_right/ga_change_data_retention.png)]




