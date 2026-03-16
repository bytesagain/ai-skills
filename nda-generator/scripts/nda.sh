#!/usr/bin/env bash
# NDA Generator - Generates complete Non-Disclosure Agreement documents
# Usage: nda.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")

show_help() {
  cat <<'EOF'
NDA Generator - 保密协议生成器

Commands:
  generate --party1 "Company A" --party2 "Company B" [--duration "2 years"]
      Generate a complete NDA document

  mutual [--party1 "Company A"] [--party2 "Company B"] [--duration "2 years"]
      Generate a mutual (bilateral) NDA

  unilateral [--discloser "Company A"] [--recipient "Company B"] [--duration "2 years"]
      Generate a unilateral (one-way) NDA

  help
      Show this help message

Options:
  --party1      First party name (default: [PARTY 1])
  --party2      Second party name (default: [PARTY 2])
  --discloser   Disclosing party (for unilateral, default: [DISCLOSING PARTY])
  --recipient   Receiving party (for unilateral, default: [RECEIVING PARTY])
  --duration    Duration of confidentiality obligations (default: 2 years)
  --governing   Governing law jurisdiction (default: People's Republic of China)

⚠️  DISCLAIMER: For reference only. Consult a qualified lawyer before use.
EOF
}

parse_args() {
  PARTY1="[PARTY 1]"
  PARTY2="[PARTY 2]"
  DISCLOSER="[DISCLOSING PARTY]"
  RECIPIENT="[RECEIVING PARTY]"
  DURATION="2 years"
  GOVERNING="the People's Republic of China"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --party1) PARTY1="$2"; shift 2 ;;
      --party2) PARTY2="$2"; shift 2 ;;
      --discloser) DISCLOSER="$2"; shift 2 ;;
      --recipient) RECIPIENT="$2"; shift 2 ;;
      --duration) DURATION="$2"; shift 2 ;;
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
legal advice. Consult a qualified attorney before executing any legal agreement.
本文档仅供参考，不构成法律建议。签署任何法律协议前请咨询专业律师。
================================================================================
EOF
}

generate_mutual() {
  parse_args "$@"
  cat <<ENDDOC
================================================================================
                    MUTUAL NON-DISCLOSURE AGREEMENT
                         双向保密协议 (NDA)
================================================================================

Date / 日期: ${DATE}

BETWEEN:

  Party A / 甲方: ${PARTY1}
  (hereinafter referred to as "Party A")

AND:

  Party B / 乙方: ${PARTY2}
  (hereinafter referred to as "Party B")

(Each individually a "Party" and collectively the "Parties")

--------------------------------------------------------------------------------
                          RECITALS / 前言
--------------------------------------------------------------------------------

WHEREAS, the Parties wish to explore a potential business relationship
(the "Purpose") and in connection therewith, each Party may disclose to the
other Party certain confidential and proprietary information;

NOW, THEREFORE, in consideration of the mutual covenants and agreements set
forth herein, and for other good and valuable consideration, the receipt and
sufficiency of which are hereby acknowledged, the Parties agree as follows:

--------------------------------------------------------------------------------
                    1. DEFINITION OF CONFIDENTIAL INFORMATION
                       保密信息的定义
--------------------------------------------------------------------------------

1.1 "Confidential Information" means any and all non-public information,
    whether in written, oral, electronic, visual, or other form, disclosed
    by either Party (the "Disclosing Party") to the other Party (the
    "Receiving Party"), including but not limited to:

    (a) Trade secrets, inventions, patents, copyrights, trademarks, and
        other intellectual property;
    (b) Business plans, strategies, forecasts, and financial information;
    (c) Customer lists, supplier information, and market data;
    (d) Technical data, designs, algorithms, software, and source code;
    (e) Employee information and organizational structures;
    (f) Any information marked as "Confidential," "Proprietary," or
        with similar designation.

1.2 Confidential Information shall NOT include information that:

    (a) Is or becomes publicly available through no fault of the
        Receiving Party;
    (b) Was already known to the Receiving Party prior to disclosure,
        as evidenced by written records;
    (c) Is independently developed by the Receiving Party without use
        of the Confidential Information;
    (d) Is lawfully obtained from a third party without breach of any
        confidentiality obligation;
    (e) Is required to be disclosed by law, regulation, or court order,
        provided the Receiving Party gives prompt notice to the
        Disclosing Party.

--------------------------------------------------------------------------------
                    2. OBLIGATIONS OF THE RECEIVING PARTY
                       接收方的义务
--------------------------------------------------------------------------------

2.1 The Receiving Party shall:

    (a) Hold all Confidential Information in strict confidence;
    (b) Not disclose any Confidential Information to any third party
        without the prior written consent of the Disclosing Party;
    (c) Use the Confidential Information solely for the Purpose;
    (d) Take all reasonable measures to protect the confidentiality of
        the Confidential Information, using at least the same degree of
        care it uses to protect its own confidential information, but
        in no event less than reasonable care;
    (e) Limit access to Confidential Information to those employees,
        agents, or advisors who have a need to know and who are bound
        by confidentiality obligations no less restrictive than this
        Agreement.

2.2 The Receiving Party shall promptly notify the Disclosing Party upon
    discovery of any unauthorized use or disclosure of Confidential
    Information.

--------------------------------------------------------------------------------
                    3. TERM AND DURATION
                       期限与持续时间
--------------------------------------------------------------------------------

3.1 This Agreement shall be effective from the date first written above and
    shall continue for a period of ${DURATION} (the "Term"), unless earlier
    terminated by either Party upon thirty (30) days' written notice.

3.2 The confidentiality obligations under this Agreement shall survive the
    termination or expiration of this Agreement for an additional period of
    ${DURATION} from the date of termination or expiration.

--------------------------------------------------------------------------------
                    4. RETURN OF MATERIALS
                       材料归还
--------------------------------------------------------------------------------

4.1 Upon termination of this Agreement or upon request by the Disclosing
    Party, the Receiving Party shall promptly:

    (a) Return all originals and copies of Confidential Information; or
    (b) Destroy all Confidential Information in its possession and
        certify such destruction in writing.

4.2 Notwithstanding the foregoing, the Receiving Party may retain one (1)
    archival copy solely for compliance and legal purposes, subject to
    ongoing confidentiality obligations.

--------------------------------------------------------------------------------
                    5. NO LICENSE OR WARRANTY
                       无许可或保证
--------------------------------------------------------------------------------

5.1 Nothing in this Agreement grants the Receiving Party any license or
    rights in or to the Confidential Information, except the limited right
    to use it for the Purpose.

5.2 ALL CONFIDENTIAL INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
    ANY KIND, EXPRESS OR IMPLIED.

--------------------------------------------------------------------------------
                    6. REMEDIES
                       救济措施
--------------------------------------------------------------------------------

6.1 The Parties acknowledge that any breach of this Agreement may cause
    irreparable harm for which monetary damages would be inadequate. The
    Disclosing Party shall be entitled to seek injunctive relief, specific
    performance, or other equitable remedies in addition to any other
    remedies available at law.

--------------------------------------------------------------------------------
                    7. GOVERNING LAW AND DISPUTE RESOLUTION
                       适用法律与争议解决
--------------------------------------------------------------------------------

7.1 This Agreement shall be governed by and construed in accordance with
    the laws of ${GOVERNING}.

7.2 Any dispute arising out of or in connection with this Agreement shall
    first be resolved through friendly negotiation. If negotiation fails
    within thirty (30) days, the dispute shall be submitted to the
    competent court of the jurisdiction where the Disclosing Party is
    domiciled.

--------------------------------------------------------------------------------
                    8. GENERAL PROVISIONS
                       一般条款
--------------------------------------------------------------------------------

8.1 Entire Agreement: This Agreement constitutes the entire agreement
    between the Parties with respect to the subject matter hereof and
    supersedes all prior negotiations, representations, and agreements.

8.2 Amendments: No modification of this Agreement shall be effective unless
    made in writing and signed by both Parties.

8.3 Severability: If any provision of this Agreement is found to be invalid
    or unenforceable, the remaining provisions shall continue in full force
    and effect.

8.4 Assignment: Neither Party may assign this Agreement without the prior
    written consent of the other Party.

8.5 Counterparts: This Agreement may be executed in counterparts, each of
    which shall be deemed an original.

--------------------------------------------------------------------------------
                    SIGNATURES / 签署
--------------------------------------------------------------------------------

For and on behalf of ${PARTY1}:

Signature: _________________________
Name:      _________________________
Title:     _________________________
Date:      _________________________


For and on behalf of ${PARTY2}:

Signature: _________________________
Name:      _________________________
Title:     _________________________
Date:      _________________________

ENDDOC
  disclaimer
}

generate_unilateral() {
  parse_args "$@"
  # If party1/party2 provided but not discloser/recipient, use them
  if [[ "$DISCLOSER" == "[DISCLOSING PARTY]" && "$PARTY1" != "[PARTY 1]" ]]; then
    DISCLOSER="$PARTY1"
  fi
  if [[ "$RECIPIENT" == "[RECEIVING PARTY]" && "$PARTY2" != "[PARTY 2]" ]]; then
    RECIPIENT="$PARTY2"
  fi

  cat <<ENDDOC
================================================================================
                  UNILATERAL NON-DISCLOSURE AGREEMENT
                       单向保密协议 (NDA)
================================================================================

Date / 日期: ${DATE}

BETWEEN:

  Disclosing Party / 披露方: ${DISCLOSER}
  (hereinafter referred to as the "Disclosing Party")

AND:

  Receiving Party / 接收方: ${RECIPIENT}
  (hereinafter referred to as the "Receiving Party")

--------------------------------------------------------------------------------
                          RECITALS / 前言
--------------------------------------------------------------------------------

WHEREAS, the Disclosing Party possesses certain confidential and proprietary
information that it wishes to disclose to the Receiving Party for the purpose
of evaluating a potential business relationship (the "Purpose");

WHEREAS, the Receiving Party agrees to receive such information under the
terms and conditions set forth in this Agreement;

NOW, THEREFORE, the Parties agree as follows:

--------------------------------------------------------------------------------
                    1. DEFINITION OF CONFIDENTIAL INFORMATION
                       保密信息的定义
--------------------------------------------------------------------------------

1.1 "Confidential Information" means all non-public information disclosed
    by the Disclosing Party to the Receiving Party, whether in written,
    oral, electronic, or other form, including but not limited to:

    (a) Trade secrets, know-how, inventions, and intellectual property;
    (b) Business operations, plans, strategies, and financial data;
    (c) Technical specifications, designs, and source code;
    (d) Customer and supplier information;
    (e) Any materials marked "Confidential" or reasonably understood
        to be confidential given the nature of the information.

1.2 Exclusions: Confidential Information does not include information that:

    (a) Is or becomes publicly known through no breach of this Agreement;
    (b) Was known to the Receiving Party before disclosure;
    (c) Is independently developed without reference to Confidential
        Information;
    (d) Is received from a third party free of confidentiality obligations;
    (e) Is required to be disclosed by applicable law or regulation.

--------------------------------------------------------------------------------
              2. OBLIGATIONS OF THE RECEIVING PARTY
                 接收方的义务
--------------------------------------------------------------------------------

2.1 The Receiving Party agrees to:

    (a) Maintain all Confidential Information in strict confidence;
    (b) Not disclose Confidential Information to any third party without
        prior written consent of the Disclosing Party;
    (c) Use Confidential Information only for the Purpose described above;
    (d) Protect Confidential Information with at least the same degree of
        care used for its own confidential information, but no less than
        reasonable care;
    (e) Restrict access to authorized personnel who need to know and who
        are bound by similar confidentiality obligations.

2.2 The Receiving Party shall immediately notify the Disclosing Party of
    any suspected or actual unauthorized disclosure or use.

--------------------------------------------------------------------------------
                    3. TERM
                       期限
--------------------------------------------------------------------------------

3.1 This Agreement is effective from the date above and continues for
    ${DURATION}, unless terminated earlier by the Disclosing Party with
    thirty (30) days' written notice.

3.2 Confidentiality obligations survive termination for ${DURATION}.

--------------------------------------------------------------------------------
                    4. RETURN OF MATERIALS
                       材料归还
--------------------------------------------------------------------------------

4.1 Upon request or termination, the Receiving Party shall return or
    destroy all Confidential Information and certify destruction in writing.

--------------------------------------------------------------------------------
                    5. NO RIGHTS GRANTED
                       未授予权利
--------------------------------------------------------------------------------

5.1 No license, intellectual property rights, or other rights are granted
    to the Receiving Party under this Agreement except the limited right to
    review Confidential Information for the Purpose.

5.2 All Confidential Information remains the property of the Disclosing
    Party.

--------------------------------------------------------------------------------
                    6. REMEDIES
                       救济措施
--------------------------------------------------------------------------------

6.1 The Receiving Party acknowledges that breach may cause irreparable
    harm. The Disclosing Party is entitled to seek injunctive relief and
    other equitable remedies in addition to any legal remedies.

--------------------------------------------------------------------------------
                    7. GOVERNING LAW
                       适用法律
--------------------------------------------------------------------------------

7.1 This Agreement is governed by the laws of ${GOVERNING}.

7.2 Disputes shall be resolved through negotiation first, then submitted
    to the competent court where the Disclosing Party is domiciled.

--------------------------------------------------------------------------------
                    8. GENERAL PROVISIONS
                       一般条款
--------------------------------------------------------------------------------

8.1 This Agreement is the entire agreement on this subject matter.
8.2 Amendments must be in writing and signed by both Parties.
8.3 Invalid provisions do not affect remaining provisions.
8.4 No assignment without written consent.

--------------------------------------------------------------------------------
                    SIGNATURES / 签署
--------------------------------------------------------------------------------

Disclosing Party / 披露方: ${DISCLOSER}

Signature: _________________________
Name:      _________________________
Title:     _________________________
Date:      _________________________


Receiving Party / 接收方: ${RECIPIENT}

Signature: _________________________
Name:      _________________________
Title:     _________________________
Date:      _________________________

ENDDOC
  disclaimer
}

# Main command router
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  generate|mutual)
    generate_mutual "$@"
    ;;
  unilateral)
    generate_unilateral "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'nda.sh help' for usage information."
    exit 1
    ;;
esac
