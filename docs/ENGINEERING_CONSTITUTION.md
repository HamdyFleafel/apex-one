# ENGINEERING_CONSTITUTION.md

> **Project:** APEXONE Enterprise Platform
> **Document ID:** ENG-CON-001
> **Version:** 1.0.0
> **Status:** Approved
> **Owner:** Hamdy Fleafel
> **Architecture Authority:** APEXONE Engineering Governance
> **Effective Date:** 2026-08-02

---

# 1. Purpose

تحدد هذه الوثيقة المبادئ والقواعد والمعايير الهندسية الملزمة لجميع أعمال التطوير الخاصة بمشروع **APEXONE Enterprise Platform**.

تعتبر هذه الوثيقة المرجع الأعلى لجميع الأعمال الفنية داخل المشروع، ولا يجوز مخالفتها إلا من خلال قرار معماري رسمي (Architecture Decision Record - ADR).

---

# 2. Vision

بناء منصة مؤسسية (Enterprise Platform) تعتمد على Oracle Database وOracle APEX وتتميز بأنها:

* قابلة للتوسع.
* قابلة للصيانة.
* آمنة.
* عالية الأداء.
* قابلة لإعادة البناء بالكامل من مستودع Git.

---

# 3. Engineering Philosophy

يعتمد المشروع المبادئ التالية:

1. Documentation First.
2. Architecture Before Implementation.
3. Security First.
4. Database First.
5. Git First.
6. Automation First.
7. One Object Per File.
8. Convention Over Configuration.
9. Simplicity Over Complexity.
10. Enterprise Quality Over Speed.

---

# 4. Project Principles

يلتزم المشروع بما يلي:

* جميع الأعمال يجب أن تكون قابلة للتكرار.
* جميع التغييرات يجب أن تكون موثقة.
* جميع الكائنات يجب أن تكون تحت إدارة Git.
* جميع التعديلات تمر عبر Migration.
* لا يوجد تنفيذ يدوي غير موثق.

---

# 5. Repository Governance

يعتبر مستودع Git المرجع الرسمي الوحيد للمشروع.

أي تغيير لا يوجد داخل المستودع يعتبر غير معتمد.

---

# 6. Database Principles

يعتمد المشروع المبادئ التالية:

* Oracle AI Database 26ai.
* Oracle APEX 26.1.
* Container: FREEPDB1.
* Schema Owner: APEXONE.
* Tablespace: APEXONE_DATA.
* Character Set: AL32UTF8.
* Deployment باستخدام Migration Framework.

---

# 7. Primary Key Strategy

يعتمد المشروع:

* Primary Key من نوع NUMBER.
* استخدام SEQUENCE لتوليد المفاتيح.
* يمكن إضافة PUBLIC_ID لاحقًا عند الحاجة للتكاملات الخارجية.

---

# 8. Object Standards

يلتزم المشروع بما يلي:

* ملف واحد لكل كائن.
* اسم واضح لكل ملف.
* Header موحد لكل ملف.
* COMMENT ON لجميع الكائنات المهمة.

---

# 9. SQL Standards

كل ملف SQL يجب أن يحتوي على:

* اسم المشروع.
* اسم الملف.
* الإصدار.
* الغرض.
* المؤلف.
* تاريخ الإنشاء.
* الاعتماديات.

---

# 10. Security Principles

يحظر استخدام SYS أو SYSTEM للتطوير.

جميع التطوير يتم من خلال Schema:

APEXONE

---

# 11. Git Principles

يلتزم المشروع بما يلي:

* Commit برسائل واضحة.
* Working Tree نظيف قبل إنهاء أي Sprint.
* عدم حذف تاريخ Git.
* عدم تخزين كلمات المرور أو الأسرار داخل المستودع.

---

# 12. Documentation Principles

أي قرار معماري يجب أن يسجل داخل ADR.

أي تغيير مؤثر يجب أن ينعكس في الوثائق.

---

# 13. Quality Gates

لا تعتبر أي مهمة مكتملة إلا إذا:

* نجح التنفيذ.
* نجحت المراجعة.
* نجح التحقق.
* تم تحديث الوثائق عند الحاجة.
* أصبح git status نظيفًا.

---

# 14. Definition of Ready

لا يبدأ تنفيذ أي مهمة إلا إذا:

* الهدف واضح.
* نطاق العمل معروف.
* التأثير على المشروع مفهوم.
* طريقة الاختبار معروفة.
* معايير القبول محددة.

---

# 15. Definition of Done

تعتبر المهمة منتهية فقط عند:

* اكتمال التنفيذ.
* نجاح الاختبارات.
* نجاح Verification.
* تحديث الوثائق.
* اعتماد Commit.

---

# 16. Change Management

أي تغيير في:

* Architecture
* Database
* Security
* Standards

يستلزم إنشاء ADR جديد أو تحديث ADR قائم.

---

# 17. Release Management

كل Release يجب أن يحتوي على:

* Release Notes.
* قائمة التغييرات.
* Verification Report.
* Git Tag.
* Version Number.

---

# 18. Code Review Policy

أي كود جديد يجب أن يراجع قبل اعتماده وفق قائمة مراجعة المشروع.

---

# 19. Continuous Improvement

يجوز تحسين هذه الوثيقة بشرط:

* وجود سبب واضح.
* توثيق التغيير.
* تحديث Revision History.
* اعتماد التعديل.

---

# 20. Amendment Policy

لا يجوز تعديل هذه الوثيقة إلا بعد:

1. مراجعة التأثير.
2. تحديث Decision Log.
3. تحديث ADR عند الحاجة.
4. اعتماد الإصدار الجديد.

---

# Revision History

| Version | Date       | Description                      |
| ------- | ---------- | -------------------------------- |
| 1.0.0   | 2026-08-02 | Initial Engineering Constitution |

---

# Approval

| Role                | Name                 | Status   |
| ------------------- | -------------------- | -------- |
| Project Owner       | Hamdy Fleafel        | Approved |
| Technical Architect | APEXONE Architecture | Approved |

---

# Related Documents

* PROJECT_CHARTER.md
* Project_Decisions.md
* Naming_Standards.md
* DATABASE_STANDARDS.md
* SECURITY_STANDARDS.md
* GIT_WORKFLOW.md
* ADR-001 Primary Key Strategy
* ADR-002 Schema Strategy
* ADR-003 Tablespace Strategy

---

**End of Document**
