# Risk Assessment Report — University Financial Application System

## Executive Summary

This project applies the NIST SP 800-30 Revision 1 risk assessment framework to a university financial application system handling sensitive financial records, HR data, and payroll — a Tier 1 environment where a breach would carry both significant financial and reputational consequences.

The work follows the full NIST 800-30 lifecycle: IT system characterisation and boundary analysis, vulnerability identification across physical, logical, and administrative control domains, likelihood and impact determination, and the development of prioritised risk mitigation strategies.

Critical findings span multiple control layers: outdated password configurations exposing systems to brute-force attacks, absence of periodic access reviews enabling persistent unauthorised access, delayed account deprovisioning creating insider threat vectors, single-point-of-failure backup architecture (on-premises only), and BYOD policy gaps that expand the organisation's attack surface. All findings are rated high likelihood and high impact across Tier 1–3 systems.

Recommended controls include zero-trust architecture, MFA enforcement, automated access review workflows, role-based and attribute-based access controls, off-site backup infrastructure, and enhanced IDS/IPS with continuous network traffic monitoring.

**Key skills demonstrated:** NIST SP 800-30 risk assessment methodology, IT system boundary analysis, multi-domain vulnerability identification (physical/logical/administrative), likelihood and impact scoring, insider threat analysis, zero-trust architecture advisory, access control design, and risk register documentation.
