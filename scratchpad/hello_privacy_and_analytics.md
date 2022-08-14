@def title = "Hello to Privacy-conscious Analytics"
@def published = "7 August 2022"
@def tags = ["housekeeping","privacy"]

# TL;DR
Traffic on this blog is tracked by Google Analytics in line with the requirements set out by existing regulations across various jurisdictions. You can find the details in the [Privacy Policy](/privacy_policy/).

# Tracking websites in the world with GDPR
I'm obsessed by continuously improving everything I do, so I was quite keen to introduce analytics to this blog as well.

However, one can no longer simply add a Google Analytics script that uses cookies. That would actually constitute a breach of existing regulations because: 1) it uses cookies, which require user's explicit consent, 2) it uses IP addresses, which are consider Personal Identifiable Information, and, hence require special treatment and codification of your practices (Privacy Policy).

Unfortunately, there isn't any free / open-source end-to-end solution that is fully compliant.

# Re-introducing Google Analytics
After some research, I've landed on Google Analytics with Google Tag Manager for the orchestration/deployment.
I've used Termly for producing the Privacy Policy, Cookie Policy and Consent Management (eg, to the use of cookies).

# How to do it?
I aim to a write blog post about the full process and also some tips for the things that turned out to be difficult (eg, reducing Google Analytics' cookie expiration period from its default 24 months to 1 month)


