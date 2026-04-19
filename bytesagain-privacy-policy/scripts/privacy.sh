#!/usr/bin/env bash
# Privacy Policy Generator - Generates complete privacy policy documents
# Usage: privacy.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")

show_help() {
  cat <<'EOF'
Privacy Policy Generator - 隐私政策生成器

Commands:
  generate --company "MyApp" --email "privacy@myapp.com" [--type web|app|both]
      Generate a complete privacy policy

  gdpr --company "MyApp" --email "dpo@myapp.com"
      Generate a GDPR-compliant privacy policy (EU)

  ccpa --company "MyApp" --email "privacy@myapp.com"
      Generate a CCPA-compliant privacy policy (California)

  help
      Show this help message

Options:
  --company   Company or app name (default: [COMPANY NAME])
  --email     Privacy contact email (default: [PRIVACY EMAIL])
  --website   Website URL (default: [WEBSITE URL])
  --type      Type: web, app, or both (default: both)
  --dpo       Data Protection Officer name (GDPR, default: [DPO NAME])

⚠️  DISCLAIMER: For reference only. Consult a qualified lawyer before use.
EOF
}

COMPANY="[COMPANY NAME]"
EMAIL="[PRIVACY EMAIL]"
WEBSITE="[WEBSITE URL]"
TYPE="both"
DPO="[DPO NAME]"

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --company) COMPANY="$2"; shift 2 ;;
      --email) EMAIL="$2"; shift 2 ;;
      --website) WEBSITE="$2"; shift 2 ;;
      --type) TYPE="$2"; shift 2 ;;
      --dpo) DPO="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
}

disclaimer() {
  cat <<'EOF'

================================================================================
⚠️  DISCLAIMER / 免责声明
This document is generated for reference purposes only and does not constitute
legal advice. Consult a qualified attorney to ensure compliance with applicable
privacy laws and regulations.
本文档仅供参考，不构成法律建议。请咨询专业律师以确保符合适用的隐私法律法规。
================================================================================
EOF
}

generate_standard() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
                         PRIVACY POLICY
                          隐私政策
================================================================================

Last Updated / 最后更新: ${DATE}

${COMPANY} ("we," "us," or "our") is committed to protecting your privacy.
This Privacy Policy explains how we collect, use, disclose, and safeguard
your information when you visit our website/application.

Please read this Privacy Policy carefully. By using our services, you agree
to the collection and use of information in accordance with this policy.

--------------------------------------------------------------------------------
                1. INFORMATION WE COLLECT
                   我们收集的信息
--------------------------------------------------------------------------------

1.1 Personal Information You Provide

  When you use our services, we may ask you to provide certain personally
  identifiable information, including but not limited to:

  • Full name
  • Email address (${EMAIL} for privacy inquiries)
  • Phone number
  • Mailing address
  • Payment information (credit card number, billing address)
  • Account credentials (username, password)
  • Date of birth
  • Profile information (avatar, bio, preferences)

1.2 Information Collected Automatically

  When you access our services, we automatically collect certain information:

  • Device Information: Device type, operating system, unique device
    identifiers, browser type and version
  • Log Data: IP address, access times, pages viewed, referring URLs,
    click patterns
  • Cookies and Tracking Technologies: We use cookies, web beacons, and
    similar technologies to track activity and hold certain information
  • Location Data: Approximate location based on IP address; precise
    location if you grant permission (mobile apps only)
  • Usage Data: Features used, interactions, session duration, frequency

1.3 Information from Third Parties

  We may receive information from third-party services when you:

  • Sign in using social media accounts (e.g., Google, Facebook, WeChat)
  • Use integrated third-party services
  • Are referred by partners or affiliates

--------------------------------------------------------------------------------
                2. HOW WE USE YOUR INFORMATION
                   我们如何使用您的信息
--------------------------------------------------------------------------------

We use the collected information for the following purposes:

  • Provide and maintain our services
  • Process transactions and send related information
  • Send administrative information (updates, security alerts)
  • Respond to your comments, questions, and customer service requests
  • Personalize your experience and deliver tailored content
  • Analyze usage trends to improve our services
  • Detect, prevent, and address technical issues and fraud
  • Comply with legal obligations
  • Send marketing communications (with your consent)
  • Conduct research and analytics

--------------------------------------------------------------------------------
                3. HOW WE SHARE YOUR INFORMATION
                   我们如何共享您的信息
--------------------------------------------------------------------------------

We may share your information in the following situations:

3.1 Service Providers: We share information with third-party vendors who
    perform services on our behalf (hosting, analytics, payment processing,
    email delivery, customer support).

3.2 Business Transfers: In connection with a merger, acquisition, or sale
    of assets, your information may be transferred.

3.3 Legal Requirements: We may disclose information if required by law,
    court order, or governmental authority.

3.4 Protection of Rights: To protect the rights, property, or safety of
    ${COMPANY}, our users, or the public.

3.5 With Your Consent: We may share information for any other purpose with
    your explicit consent.

We do NOT sell your personal information to third parties.

--------------------------------------------------------------------------------
                4. DATA SECURITY
                   数据安全
--------------------------------------------------------------------------------

We implement appropriate technical and organizational security measures to
protect your personal information, including:

  • Encryption of data in transit (TLS/SSL) and at rest
  • Regular security assessments and penetration testing
  • Access controls and authentication mechanisms
  • Employee security training and awareness programs
  • Incident response procedures

However, no method of transmission over the Internet or electronic storage
is 100% secure. We cannot guarantee absolute security.

--------------------------------------------------------------------------------
                5. DATA RETENTION
                   数据保留
--------------------------------------------------------------------------------

We retain your personal information only for as long as necessary to fulfill
the purposes outlined in this Privacy Policy, unless a longer retention
period is required by law.

Retention criteria include:
  • Duration of your account/relationship with us
  • Legal obligations (tax, accounting, regulatory requirements)
  • Statute of limitations for potential legal claims
  • Business necessity

When data is no longer needed, we securely delete or anonymize it.

--------------------------------------------------------------------------------
                6. YOUR RIGHTS AND CHOICES
                   您的权利和选择
--------------------------------------------------------------------------------

Depending on your jurisdiction, you may have the following rights:

  • Access: Request a copy of your personal information
  • Correction: Request correction of inaccurate data
  • Deletion: Request deletion of your personal information
  • Portability: Request your data in a structured, machine-readable format
  • Restriction: Request restriction of processing
  • Objection: Object to processing based on legitimate interests
  • Withdraw Consent: Withdraw consent at any time (without affecting
    the lawfulness of prior processing)
  • Opt-Out: Opt out of marketing communications

To exercise these rights, contact us at: ${EMAIL}

We will respond to your request within 30 days.

--------------------------------------------------------------------------------
                7. COOKIES AND TRACKING
                   Cookie 和追踪技术
--------------------------------------------------------------------------------

7.1 Types of Cookies We Use:

  • Essential Cookies: Required for basic functionality
  • Analytics Cookies: Help us understand usage patterns (e.g., Google
    Analytics)
  • Preference Cookies: Remember your settings and preferences
  • Marketing Cookies: Used to deliver relevant advertisements

7.2 Managing Cookies:

  You can control cookies through your browser settings. Note that
  disabling cookies may affect functionality.

7.3 Do Not Track:

  We currently do not respond to "Do Not Track" browser signals.

--------------------------------------------------------------------------------
                8. CHILDREN'S PRIVACY
                   儿童隐私
--------------------------------------------------------------------------------

Our services are not directed to individuals under 16 years of age (or the
applicable age of consent in your jurisdiction). We do not knowingly collect
personal information from children. If we discover that we have collected
information from a child, we will promptly delete it.

If you believe a child has provided us with personal information, please
contact us at: ${EMAIL}

--------------------------------------------------------------------------------
                9. INTERNATIONAL DATA TRANSFERS
                   国际数据传输
--------------------------------------------------------------------------------

Your information may be transferred to and processed in countries other than
your country of residence. These countries may have different data protection
laws. We ensure appropriate safeguards are in place, such as:

  • Standard Contractual Clauses (SCCs)
  • Adequacy decisions
  • Binding Corporate Rules

--------------------------------------------------------------------------------
                10. THIRD-PARTY LINKS
                    第三方链接
--------------------------------------------------------------------------------

Our services may contain links to third-party websites or services. We are
not responsible for the privacy practices of these third parties. We
encourage you to review their privacy policies.

--------------------------------------------------------------------------------
                11. CHANGES TO THIS POLICY
                    政策变更
--------------------------------------------------------------------------------

We may update this Privacy Policy from time to time. We will notify you of
any material changes by:

  • Posting the updated policy on our website
  • Sending you an email notification
  • Displaying a prominent notice in our application

Your continued use of our services after changes become effective constitutes
acceptance of the updated policy.

--------------------------------------------------------------------------------
                12. CONTACT US
                    联系我们
--------------------------------------------------------------------------------

If you have questions about this Privacy Policy or our privacy practices,
please contact us:

  Company:  ${COMPANY}
  Email:    ${EMAIL}
  Website:  ${WEBSITE}

For privacy complaints, you may also contact your local data protection
authority.

ENDDOC
  disclaimer
}

generate_gdpr() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
               PRIVACY POLICY — GDPR COMPLIANT
               隐私政策 — 符合GDPR（欧盟通用数据保护条例）
================================================================================

Last Updated / 最后更新: ${DATE}
Data Controller / 数据控制者: ${COMPANY}
Data Protection Officer / 数据保护官: ${DPO}
Contact / 联系方式: ${EMAIL}

This Privacy Policy is designed to comply with the General Data Protection
Regulation (EU) 2016/679 ("GDPR"). It describes how ${COMPANY} collects,
processes, and protects personal data of individuals in the European Economic
Area (EEA), United Kingdom, and Switzerland.

--------------------------------------------------------------------------------
                1. DATA CONTROLLER / 数据控制者
--------------------------------------------------------------------------------

${COMPANY} acts as the Data Controller for personal data processed under
this policy. Our Data Protection Officer (DPO) can be reached at:

  Name:  ${DPO}
  Email: ${EMAIL}

--------------------------------------------------------------------------------
                2. LEGAL BASES FOR PROCESSING (Article 6 GDPR)
                   处理的法律依据
--------------------------------------------------------------------------------

We process your personal data based on the following legal grounds:

  (a) Consent (Art. 6(1)(a)): You have given clear consent for one or
      more specific purposes.

  (b) Contract Performance (Art. 6(1)(b)): Processing is necessary for
      the performance of a contract with you.

  (c) Legal Obligation (Art. 6(1)(c)): Processing is necessary for
      compliance with a legal obligation.

  (d) Vital Interests (Art. 6(1)(d)): Processing is necessary to protect
      the vital interests of you or another person.

  (e) Legitimate Interests (Art. 6(1)(f)): Processing is necessary for
      our legitimate interests, provided they are not overridden by your
      rights and freedoms.

For each processing activity, we document the applicable legal basis in our
Record of Processing Activities (ROPA).

--------------------------------------------------------------------------------
                3. DATA COLLECTED AND PURPOSES
                   收集的数据及目的
--------------------------------------------------------------------------------

| Data Category           | Purpose                    | Legal Basis       |
|-------------------------|----------------------------|-------------------|
| Name, Email             | Account creation           | Contract          |
| Payment Details         | Transaction processing     | Contract          |
| IP Address, Device Info | Security & fraud prevention| Legitimate Interest|
| Usage Analytics         | Service improvement        | Legitimate Interest|
| Marketing Preferences   | Promotional communications | Consent           |
| Support Tickets         | Customer support           | Contract          |

--------------------------------------------------------------------------------
                4. YOUR RIGHTS UNDER GDPR
                   您在GDPR下的权利
--------------------------------------------------------------------------------

Under GDPR, you have the following rights:

  (a) Right of Access (Art. 15): Obtain confirmation of whether your data
      is being processed and request a copy.

  (b) Right to Rectification (Art. 16): Request correction of inaccurate
      personal data.

  (c) Right to Erasure / "Right to Be Forgotten" (Art. 17): Request
      deletion of your personal data under certain conditions.

  (d) Right to Restriction (Art. 18): Request restriction of processing
      under certain conditions.

  (e) Right to Data Portability (Art. 20): Receive your data in a
      structured, commonly used, machine-readable format.

  (f) Right to Object (Art. 21): Object to processing based on legitimate
      interests or direct marketing.

  (g) Right Not to Be Subject to Automated Decision-Making (Art. 22):
      Not be subject to decisions based solely on automated processing,
      including profiling, that produce legal effects.

  (h) Right to Withdraw Consent (Art. 7(3)): Withdraw consent at any
      time without affecting prior processing.

To exercise any right, email: ${EMAIL}
Response time: Within 30 days (extendable by 60 days for complex requests).

--------------------------------------------------------------------------------
                5. INTERNATIONAL DATA TRANSFERS
                   国际数据传输
--------------------------------------------------------------------------------

When we transfer personal data outside the EEA, we use:

  • EU Standard Contractual Clauses (SCCs) — Commission Decision 2021/914
  • Adequacy Decisions where available
  • Binding Corporate Rules for intra-group transfers

You may request a copy of the safeguards by contacting ${EMAIL}.

--------------------------------------------------------------------------------
                6. DATA RETENTION / 数据保留
--------------------------------------------------------------------------------

We retain personal data only as long as necessary for the stated purposes:

  • Account data: Duration of account + 30 days after deletion request
  • Transaction records: 7 years (legal/tax requirements)
  • Marketing data: Until consent withdrawal
  • Log data: 12 months
  • Support tickets: 3 years after resolution

--------------------------------------------------------------------------------
                7. DATA SECURITY / 数据安全
--------------------------------------------------------------------------------

We implement measures per Article 32 GDPR:

  • Encryption (TLS 1.2+ in transit, AES-256 at rest)
  • Pseudonymization where possible
  • Access controls (role-based, principle of least privilege)
  • Regular security testing and audits
  • Data breach notification procedures (72 hours to supervisory authority)
  • Employee training on data protection

--------------------------------------------------------------------------------
                8. DATA PROTECTION IMPACT ASSESSMENTS (DPIA)
                   数据保护影响评估
--------------------------------------------------------------------------------

We conduct DPIAs for processing activities likely to result in high risk to
individuals' rights and freedoms, as required by Article 35 GDPR.

--------------------------------------------------------------------------------
                9. COOKIES / Cookie政策
--------------------------------------------------------------------------------

We use cookies in compliance with the ePrivacy Directive. Users are
presented with a cookie consent banner upon first visit. Categories:

  • Strictly Necessary: Always active (no consent required)
  • Analytics: Require consent
  • Marketing: Require consent
  • Preference: Require consent

You can manage preferences via our cookie settings panel or browser settings.

--------------------------------------------------------------------------------
                10. COMPLAINTS / 投诉
--------------------------------------------------------------------------------

You have the right to lodge a complaint with your local supervisory
authority. A list of EEA supervisory authorities is available at:
https://edpb.europa.eu/about-edpb/about-edpb/members_en

You may also contact us first at: ${EMAIL}

--------------------------------------------------------------------------------
                11. CHANGES / 变更
--------------------------------------------------------------------------------

Material changes will be communicated via email and/or prominent website
notice at least 30 days before taking effect.

--------------------------------------------------------------------------------
                12. CONTACT / 联系方式
--------------------------------------------------------------------------------

  Data Controller: ${COMPANY}
  DPO:            ${DPO}
  Email:          ${EMAIL}
  Website:        ${WEBSITE}

ENDDOC
  disclaimer
}

generate_ccpa() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
            PRIVACY POLICY — CCPA COMPLIANT
            隐私政策 — 符合CCPA（加州消费者隐私法案）
================================================================================

Last Updated / 最后更新: ${DATE}
Company / 公司: ${COMPANY}
Contact / 联系方式: ${EMAIL}

This Privacy Policy supplements the information contained in our general
Privacy Policy and applies solely to visitors, users, and others who reside
in the State of California ("consumers" or "you"). We adopt this notice to
comply with the California Consumer Privacy Act of 2018 ("CCPA") and the
California Privacy Rights Act of 2020 ("CPRA"), and any terms defined in
the CCPA/CPRA have the same meaning when used in this notice.

--------------------------------------------------------------------------------
        1. CATEGORIES OF PERSONAL INFORMATION COLLECTED
           收集的个人信息类别
--------------------------------------------------------------------------------

In the preceding 12 months, we have collected the following categories
of personal information from consumers:

| Category                              | Examples                          | Collected |
|---------------------------------------|-----------------------------------|-----------|
| A. Identifiers                        | Name, email, IP address, account  | YES       |
| B. CA Customer Records                | Name, address, phone, financial   | YES       |
| C. Protected Classifications          | Age, gender (if provided)         | NO        |
| D. Commercial Information             | Purchase history, preferences     | YES       |
| E. Biometric Information              | Fingerprints, face geometry       | NO        |
| F. Internet/Network Activity          | Browsing history, search history  | YES       |
| G. Geolocation Data                   | Approximate location via IP       | YES       |
| H. Sensory Data                       | Audio, video recordings           | NO        |
| I. Professional/Employment Info       | Job title, employer               | NO        |
| J. Education Information              | Degree, school                    | NO        |
| K. Inferences                         | Preferences, characteristics      | YES       |
| L. Sensitive Personal Information     | Precise geolocation, SSN, etc.    | NO        |

--------------------------------------------------------------------------------
        2. SOURCES OF PERSONAL INFORMATION
           个人信息来源
--------------------------------------------------------------------------------

We collect personal information from the following sources:

  • Directly from you (registration, purchases, support requests)
  • Automatically from your device (cookies, analytics, log files)
  • Third-party service providers (analytics, advertising partners)
  • Public sources (social media profiles, public records)

--------------------------------------------------------------------------------
        3. USE OF PERSONAL INFORMATION
           个人信息的使用
--------------------------------------------------------------------------------

We use personal information for the following business purposes:

  • Providing and maintaining our services
  • Processing transactions
  • Communicating with you
  • Improving and personalizing our services
  • Security and fraud prevention
  • Compliance with legal obligations
  • Marketing (with your consent where required)

We will not collect additional categories of personal information or use
collected information for materially different purposes without notice.

--------------------------------------------------------------------------------
        4. SALE AND SHARING OF PERSONAL INFORMATION
           个人信息的出售和共享
--------------------------------------------------------------------------------

${COMPANY} does NOT sell personal information as defined by the CCPA/CPRA.

We may share personal information with service providers for business
purposes. In the preceding 12 months, we have disclosed the following
categories for a business purpose:

  • Category A: Identifiers (to service providers for analytics)
  • Category D: Commercial information (to payment processors)
  • Category F: Internet activity (to analytics providers)

--------------------------------------------------------------------------------
        5. YOUR RIGHTS UNDER CCPA/CPRA
           您在CCPA/CPRA下的权利
--------------------------------------------------------------------------------

As a California consumer, you have the following rights:

  (a) Right to Know (§1798.100, §1798.110): Request disclosure of:
      - Categories of personal information collected
      - Categories of sources
      - Business purpose for collecting
      - Categories of third parties with whom information is shared
      - Specific pieces of personal information collected

  (b) Right to Delete (§1798.105): Request deletion of your personal
      information, subject to certain exceptions.

  (c) Right to Correct (§1798.106, CPRA): Request correction of
      inaccurate personal information.

  (d) Right to Opt-Out of Sale/Sharing (§1798.120): Direct us to stop
      selling or sharing your personal information. (We do not sell data.)

  (e) Right to Limit Use of Sensitive Information (§1798.121, CPRA):
      Limit use of sensitive personal information to specific purposes.

  (f) Right to Non-Discrimination (§1798.125): We will not discriminate
      against you for exercising any CCPA rights.

--------------------------------------------------------------------------------
        6. HOW TO EXERCISE YOUR RIGHTS
           如何行使您的权利
--------------------------------------------------------------------------------

You may submit a verifiable consumer request by:

  • Email: ${EMAIL}
  • Website: ${WEBSITE}

Verification: We will verify your identity by matching information you
provide with information we have on file. We may request additional
information for verification purposes.

Authorized Agents: You may designate an authorized agent to submit
requests on your behalf. The agent must provide written authorization
signed by you.

Response Time: We will respond within 45 days of receiving your request.
If we need more time (up to 90 days total), we will inform you in writing.

--------------------------------------------------------------------------------
        7. DATA RETENTION / 数据保留
--------------------------------------------------------------------------------

We retain personal information for as long as necessary to fulfill the
purposes described in this policy. Retention periods:

  • Account data: Duration of account + 12 months
  • Transaction records: 7 years
  • Analytics data: 26 months
  • Marketing preferences: Until opt-out

--------------------------------------------------------------------------------
        8. FINANCIAL INCENTIVES / 财务激励
--------------------------------------------------------------------------------

We do not offer financial incentives or price differences in exchange for
personal information at this time. If we do so in the future, we will
provide notice and obtain your opt-in consent.

--------------------------------------------------------------------------------
        9. MINORS / 未成年人
--------------------------------------------------------------------------------

We do not knowingly collect personal information from consumers under
16 years of age. If we learn we have collected information from a minor,
we will delete it promptly.

For consumers between 13 and 16, we require opt-in consent before any
sale of personal information (not applicable as we do not sell data).

--------------------------------------------------------------------------------
        10. CONTACT / 联系方式
--------------------------------------------------------------------------------

For questions or to exercise your rights:

  Company:  ${COMPANY}
  Email:    ${EMAIL}
  Website:  ${WEBSITE}

ENDDOC
  disclaimer
}

# Main command router
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  generate)
    generate_standard "$@"
    ;;
  gdpr)
    generate_gdpr "$@"
    ;;
  ccpa)
    generate_ccpa "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'privacy.sh help' for usage information."
    exit 1
    ;;
esac
