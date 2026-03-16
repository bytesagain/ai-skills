#!/usr/bin/env bash
# Terms of Service Generator - Generates complete TOS documents
# Usage: tos.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")

show_help() {
  cat <<'EOF'
Terms of Service Generator - 服务条款生成器

Commands:
  generate --company "MyApp" --website "myapp.com"
      Generate a complete Terms of Service

  saas --company "MyApp" --website "myapp.com"
      Generate SaaS-specific Terms of Service

  help
      Show this help message

Options:
  --company    Company or app name (default: [COMPANY NAME])
  --website    Website URL (default: [WEBSITE URL])
  --email      Contact email (default: [CONTACT EMAIL])
  --governing  Governing law jurisdiction (default: People's Republic of China)

⚠️  DISCLAIMER: For reference only. Consult a qualified lawyer before use.
EOF
}

COMPANY="[COMPANY NAME]"
WEBSITE="[WEBSITE URL]"
EMAIL="[CONTACT EMAIL]"
GOVERNING="the People's Republic of China"

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --company) COMPANY="$2"; shift 2 ;;
      --website) WEBSITE="$2"; shift 2 ;;
      --email) EMAIL="$2"; shift 2 ;;
      --governing) GOVERNING="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
}

disclaimer() {
  cat <<'EOF'

================================================================================
⚠️  DISCLAIMER / 免责声明
This document is generated for reference purposes only and does not constitute
legal advice. Consult a qualified attorney before use.
本文档仅供参考，不构成法律建议。请咨询专业律师后使用。
================================================================================
EOF
}

generate_standard() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
                        TERMS OF SERVICE
                          服务条款
================================================================================

Last Updated / 最后更新: ${DATE}

Welcome to ${COMPANY}. These Terms of Service ("Terms") govern your access
to and use of ${WEBSITE} and any related services (collectively, the
"Service") provided by ${COMPANY} ("we," "us," or "our").

By accessing or using the Service, you agree to be bound by these Terms.
If you do not agree to all of these Terms, do not use the Service.

--------------------------------------------------------------------------------
                1. ACCEPTANCE OF TERMS
                   接受条款
--------------------------------------------------------------------------------

1.1 By creating an account, accessing, or using the Service, you confirm
    that you have read, understood, and agree to be bound by these Terms
    and our Privacy Policy.

1.2 If you are using the Service on behalf of an organization, you
    represent that you have authority to bind that organization to these
    Terms.

1.3 You must be at least 16 years old (or the applicable age of consent
    in your jurisdiction) to use the Service.

--------------------------------------------------------------------------------
                2. DESCRIPTION OF SERVICE
                   服务描述
--------------------------------------------------------------------------------

2.1 ${COMPANY} provides [describe your service here]. Features may be
    added, modified, or removed at our discretion.

2.2 We reserve the right to modify, suspend, or discontinue the Service
    (or any part thereof) at any time, with or without notice.

2.3 We shall not be liable to you or any third party for any modification,
    suspension, or discontinuation of the Service.

--------------------------------------------------------------------------------
                3. USER ACCOUNTS
                   用户账户
--------------------------------------------------------------------------------

3.1 Registration: You may need to create an account to access certain
    features. You agree to provide accurate, current, and complete
    information during registration.

3.2 Account Security: You are responsible for maintaining the security
    of your account credentials. You agree to:
    • Keep your password confidential
    • Notify us immediately of any unauthorized access
    • Not share your account with others

3.3 Account Termination: We may suspend or terminate your account if:
    • You violate these Terms
    • You provide false information
    • Your account has been inactive for 12+ months
    • Required by law

--------------------------------------------------------------------------------
                4. USER CONTENT
                   用户内容
--------------------------------------------------------------------------------

4.1 Ownership: You retain ownership of content you submit to the Service
    ("User Content").

4.2 License: By submitting User Content, you grant ${COMPANY} a worldwide,
    non-exclusive, royalty-free, sublicensable license to use, reproduce,
    modify, distribute, and display such content in connection with
    operating the Service.

4.3 Responsibility: You are solely responsible for your User Content.
    You represent that:
    • You own or have rights to submit the content
    • The content does not infringe third-party rights
    • The content does not violate any laws

4.4 Prohibited Content: You may not submit content that:
    • Is illegal, harmful, threatening, abusive, or harassing
    • Infringes intellectual property rights
    • Contains viruses or malicious code
    • Is spam, advertising, or solicitation (unless permitted)
    • Violates any person's privacy
    • Is misleading or fraudulent

4.5 Removal: We reserve the right to remove any User Content at our
    discretion, without notice.

--------------------------------------------------------------------------------
                5. INTELLECTUAL PROPERTY
                   知识产权
--------------------------------------------------------------------------------

5.1 Our IP: The Service, including its design, features, content, code,
    trademarks, and logos, is owned by ${COMPANY} and protected by
    intellectual property laws.

5.2 Restrictions: You may not:
    • Copy, modify, or distribute the Service
    • Reverse engineer, decompile, or disassemble the Service
    • Remove any proprietary notices
    • Use our trademarks without written permission

5.3 Feedback: Any feedback or suggestions you provide may be used by us
    without obligation or compensation to you.

--------------------------------------------------------------------------------
                6. PROHIBITED USES
                   禁止行为
--------------------------------------------------------------------------------

You agree NOT to:

  (a) Use the Service for any unlawful purpose
  (b) Violate any applicable laws or regulations
  (c) Attempt to gain unauthorized access to any part of the Service
  (d) Interfere with or disrupt the Service or servers
  (e) Use automated systems (bots, scrapers) without permission
  (f) Impersonate any person or entity
  (g) Collect personal information of other users without consent
  (h) Use the Service to send spam or unsolicited messages
  (i) Circumvent any access controls or security measures
  (j) Use the Service in a manner that could damage our reputation

--------------------------------------------------------------------------------
                7. PAYMENT TERMS
                   支付条款
--------------------------------------------------------------------------------

7.1 Fees: Certain features may require payment. All fees are listed on
    our pricing page and are in [USD/RMB/EUR].

7.2 Billing: You authorize us to charge your payment method for fees
    incurred. Charges are non-refundable unless stated otherwise.

7.3 Price Changes: We may change fees upon 30 days' notice. Continued
    use after price changes constitutes acceptance.

7.4 Taxes: You are responsible for all applicable taxes.

7.5 Late Payments: Late payments may result in service suspension and
    may accrue interest at 1.5% per month or the maximum rate permitted
    by law.

--------------------------------------------------------------------------------
                8. DISCLAIMERS
                   免责声明
--------------------------------------------------------------------------------

8.1 THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES
    OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
    IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
    PURPOSE, AND NON-INFRINGEMENT.

8.2 We do not warrant that:
    • The Service will be uninterrupted, timely, secure, or error-free
    • Results obtained from the Service will be accurate or reliable
    • Defects will be corrected
    • The Service is free of viruses or harmful components

--------------------------------------------------------------------------------
                9. LIMITATION OF LIABILITY
                   责任限制
--------------------------------------------------------------------------------

9.1 TO THE MAXIMUM EXTENT PERMITTED BY LAW, ${COMPANY} SHALL NOT BE
    LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR
    PUNITIVE DAMAGES, INCLUDING BUT NOT LIMITED TO LOSS OF PROFITS,
    DATA, USE, OR GOODWILL.

9.2 OUR TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT YOU PAID TO US
    IN THE 12 MONTHS PRECEDING THE CLAIM, OR \$100 (USD), WHICHEVER
    IS GREATER.

9.3 These limitations apply regardless of the theory of liability
    (contract, tort, strict liability, or otherwise).

--------------------------------------------------------------------------------
                10. INDEMNIFICATION
                    赔偿
--------------------------------------------------------------------------------

You agree to indemnify, defend, and hold harmless ${COMPANY}, its
officers, directors, employees, agents, and affiliates from any claims,
damages, losses, liabilities, costs, and expenses (including reasonable
attorneys' fees) arising from:

  (a) Your use of the Service
  (b) Your violation of these Terms
  (c) Your violation of any third-party rights
  (d) Your User Content

--------------------------------------------------------------------------------
                11. GOVERNING LAW AND DISPUTES
                    适用法律与争议解决
--------------------------------------------------------------------------------

11.1 These Terms are governed by the laws of ${GOVERNING}.

11.2 Any dispute shall first be resolved through good-faith negotiation
     for at least 30 days.

11.3 If negotiation fails, disputes shall be submitted to the competent
     court in the jurisdiction of ${COMPANY}'s principal place of business.

11.4 Notwithstanding the above, either party may seek injunctive relief
     in any court of competent jurisdiction.

--------------------------------------------------------------------------------
                12. CHANGES TO TERMS
                    条款变更
--------------------------------------------------------------------------------

12.1 We may modify these Terms at any time. Material changes will be
     communicated via email or prominent notice on the Service at least
     30 days before taking effect.

12.2 Your continued use of the Service after changes constitute acceptance
     of the modified Terms.

12.3 If you do not agree to modified Terms, you must stop using the
     Service and close your account.

--------------------------------------------------------------------------------
                13. GENERAL PROVISIONS
                    一般条款
--------------------------------------------------------------------------------

13.1 Entire Agreement: These Terms, together with our Privacy Policy,
     constitute the entire agreement between you and ${COMPANY}.

13.2 Severability: If any provision is found unenforceable, the remaining
     provisions remain in effect.

13.3 Waiver: Failure to enforce any right does not constitute a waiver.

13.4 Assignment: You may not assign these Terms without our written
     consent. We may assign freely.

13.5 Force Majeure: We are not liable for failure to perform due to
     circumstances beyond our reasonable control.

13.6 Notices: We may send notices via email to your registered address
     or by posting on the Service.

--------------------------------------------------------------------------------
                14. CONTACT INFORMATION
                    联系方式
--------------------------------------------------------------------------------

For questions about these Terms:

  Company:  ${COMPANY}
  Website:  ${WEBSITE}
  Email:    ${EMAIL}

ENDDOC
  disclaimer
}

generate_saas() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
              SAAS TERMS OF SERVICE / SaaS服务条款
================================================================================

Last Updated / 最后更新: ${DATE}

These SaaS Terms of Service ("Agreement") govern your subscription to and
use of the software-as-a-service platform provided by ${COMPANY} ("Provider,"
"we," "us") accessible at ${WEBSITE} (the "Platform").

By subscribing to or using the Platform, you ("Customer," "you") agree to
this Agreement.

--------------------------------------------------------------------------------
            1. DEFINITIONS / 定义
--------------------------------------------------------------------------------

  "Authorized Users" — individuals permitted by Customer to access the
  Platform under Customer's subscription.

  "Customer Data" — all data uploaded, submitted, or generated by Customer
  or Authorized Users through the Platform.

  "Documentation" — user guides, API documentation, and help materials
  provided by Provider.

  "Service Level Agreement (SLA)" — the uptime and performance commitments
  set forth in Section 7.

  "Subscription Term" — the period during which Customer has access to
  the Platform, as specified in the applicable Order Form.

  "Order Form" — the document specifying the subscription plan, number
  of users, pricing, and term.

--------------------------------------------------------------------------------
            2. GRANT OF LICENSE / 许可授予
--------------------------------------------------------------------------------

2.1 Provider grants Customer a non-exclusive, non-transferable, limited
    right to access and use the Platform during the Subscription Term,
    subject to this Agreement.

2.2 The license is limited to:
    • The number of Authorized Users specified in the Order Form
    • Internal business purposes of Customer
    • Features included in Customer's subscription plan

2.3 Customer shall not:
    • Sublicense, resell, or distribute access to the Platform
    • Allow unauthorized users to access the Platform
    • Use the Platform to develop a competing product
    • Exceed usage limits specified in the Order Form

--------------------------------------------------------------------------------
            3. CUSTOMER DATA / 客户数据
--------------------------------------------------------------------------------

3.1 Ownership: Customer retains all rights in Customer Data. Provider
    does not claim ownership of Customer Data.

3.2 License: Customer grants Provider a limited license to use Customer
    Data solely to provide and improve the Platform.

3.3 Data Protection: Provider shall implement reasonable security
    measures to protect Customer Data, including:
    • Encryption in transit (TLS 1.2+) and at rest (AES-256)
    • Regular backups (daily, retained for 30 days)
    • Access controls and audit logging
    • Compliance with applicable data protection laws

3.4 Data Portability: Customer may export Customer Data at any time
    in standard formats (CSV, JSON, or via API).

3.5 Data Deletion: Upon termination, Provider shall delete Customer
    Data within 30 days, unless retention is required by law. Customer
    may request data export before termination.

--------------------------------------------------------------------------------
            4. SUBSCRIPTION AND PAYMENT / 订阅与付款
--------------------------------------------------------------------------------

4.1 Fees: Customer shall pay subscription fees as specified in the
    Order Form. Fees are due in advance on a [monthly/annual] basis.

4.2 Payment Terms: Invoices are due within 30 days of issue date.
    Late payments accrue interest at 1.5% per month.

4.3 Price Increases: Provider may increase fees upon 60 days' written
    notice before the next renewal term.

4.4 Taxes: Fees are exclusive of taxes. Customer is responsible for
    applicable sales, use, VAT, or other taxes.

4.5 Refunds: No refunds for partial periods unless required by law.

4.6 Suspension: Provider may suspend access for unpaid fees after
    15 days' written notice.

--------------------------------------------------------------------------------
            5. SUPPORT AND MAINTENANCE / 支持与维护
--------------------------------------------------------------------------------

5.1 Standard Support: Included in all plans:
    • Email support: Response within 24 business hours
    • Documentation and knowledge base access
    • Community forum access

5.2 Premium Support (if applicable):
    • Priority email support: Response within 4 business hours
    • Phone/video support during business hours
    • Dedicated account manager
    • Custom training sessions

5.3 Maintenance: Provider shall perform scheduled maintenance during
    off-peak hours with at least 48 hours' advance notice. Emergency
    maintenance may be performed without notice.

--------------------------------------------------------------------------------
            6. AVAILABILITY AND SLA / 可用性与SLA
--------------------------------------------------------------------------------

6.1 Uptime Commitment: Provider commits to 99.9% monthly uptime for
    the Platform ("Uptime SLA"), measured as:

    Uptime % = (Total Minutes - Downtime Minutes) / Total Minutes × 100

6.2 Exclusions: The following are excluded from downtime calculations:
    • Scheduled maintenance windows
    • Force majeure events
    • Issues caused by Customer's systems or third-party services
    • Features in beta or preview

6.3 Service Credits: If monthly uptime falls below the SLA:
    • 99.0% - 99.9%: 10% credit on monthly fee
    • 95.0% - 99.0%: 25% credit on monthly fee
    • Below 95.0%:   50% credit on monthly fee

    Credits must be requested within 30 days. Maximum credit per month
    shall not exceed 50% of monthly fees. Credits are the sole remedy
    for SLA breaches.

6.4 Status Page: Real-time status is available at [status page URL].

--------------------------------------------------------------------------------
            7. INTELLECTUAL PROPERTY / 知识产权
--------------------------------------------------------------------------------

7.1 Provider IP: The Platform, including all code, designs, algorithms,
    documentation, and trademarks, is owned by Provider.

7.2 Customer IP: Customer Data and Customer's pre-existing intellectual
    property remain Customer's property.

7.3 Feedback: Suggestions or feedback from Customer may be used by
    Provider without restriction or compensation.

--------------------------------------------------------------------------------
            8. CONFIDENTIALITY / 保密
--------------------------------------------------------------------------------

8.1 Each party agrees to keep confidential all non-public information
    received from the other party.

8.2 Confidential information does not include information that is:
    • Publicly available through no fault of the receiving party
    • Already known before disclosure
    • Independently developed
    • Received from a third party without restriction

8.3 Obligations survive for 3 years after termination.

--------------------------------------------------------------------------------
            9. WARRANTIES AND DISCLAIMERS / 保证与免责
--------------------------------------------------------------------------------

9.1 Provider warrants that the Platform will perform materially in
    accordance with the Documentation during the Subscription Term.

9.2 EXCEPT AS EXPRESSLY SET FORTH ABOVE, THE PLATFORM IS PROVIDED
    "AS IS." PROVIDER DISCLAIMS ALL OTHER WARRANTIES, EXPRESS OR
    IMPLIED, INCLUDING MERCHANTABILITY AND FITNESS FOR A PARTICULAR
    PURPOSE.

--------------------------------------------------------------------------------
            10. LIMITATION OF LIABILITY / 责任限制
--------------------------------------------------------------------------------

10.1 NEITHER PARTY SHALL BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL,
     CONSEQUENTIAL, OR PUNITIVE DAMAGES.

10.2 PROVIDER'S TOTAL LIABILITY SHALL NOT EXCEED THE FEES PAID BY
     CUSTOMER IN THE 12 MONTHS PRECEDING THE CLAIM.

10.3 These limitations do not apply to:
     • Breach of confidentiality obligations
     • Infringement of intellectual property rights
     • Customer's payment obligations
     • Gross negligence or willful misconduct

--------------------------------------------------------------------------------
            11. TERM AND TERMINATION / 期限与终止
--------------------------------------------------------------------------------

11.1 Term: This Agreement begins on the effective date and continues
     for the Subscription Term specified in the Order Form.

11.2 Auto-Renewal: The subscription automatically renews for successive
     terms of equal length unless either party provides 30 days' written
     notice before the end of the current term.

11.3 Termination for Cause: Either party may terminate if the other:
     • Materially breaches and fails to cure within 30 days of notice
     • Becomes insolvent or files for bankruptcy

11.4 Effects of Termination:
     • Customer's access to the Platform ceases
     • Customer may export data for 30 days after termination
     • Provider deletes Customer Data after the export period
     • Accrued payment obligations survive termination

--------------------------------------------------------------------------------
            12. GOVERNING LAW / 适用法律
--------------------------------------------------------------------------------

This Agreement is governed by the laws of ${GOVERNING}.

Disputes shall be resolved through negotiation, then mediation, then
arbitration or litigation in the jurisdiction of Provider's principal
place of business.

--------------------------------------------------------------------------------
            13. GENERAL / 一般条款
--------------------------------------------------------------------------------

13.1 Entire Agreement: This Agreement and any Order Forms constitute
     the entire agreement.
13.2 Amendments: Must be in writing and signed by both parties.
13.3 Severability: Invalid provisions do not affect remaining terms.
13.4 Assignment: Neither party may assign without consent, except in
     connection with a merger or acquisition.
13.5 Force Majeure: Neither party is liable for failure due to events
     beyond reasonable control.
13.6 Notices: Must be in writing to the addresses specified in the
     Order Form.

--------------------------------------------------------------------------------
            14. CONTACT / 联系方式
--------------------------------------------------------------------------------

  Provider: ${COMPANY}
  Website:  ${WEBSITE}
  Email:    ${EMAIL}

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
  saas)
    generate_saas "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'tos.sh help' for usage information."
    exit 1
    ;;
esac
