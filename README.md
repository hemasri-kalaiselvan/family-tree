# Family Tree — Multi-Family Tree, Events & Contacts App

> A mobile-first family-tree web app for several linked families — interactive trees, birthdays & memorials, contact book and powerful filters — with role-based privacy. A learning project built with AI assistance.

**Tech:** HTML, CSS, JavaScript, SQL, PostgreSQL
**Tools:** GitHub Pages, Supabase
**AI Tools:** Claude

## About

A single-page **family-tree app** that keeps four families (Vetri, Raj, Sivaraj,
Kannaiyan) in one database, draws each as an interactive tree, and adds the
everyday tools a family actually needs — who has a birthday this week, whose
phone number is it, who shares a kothram.

- **Frontend:** one self-contained `index.html` (HTML + CSS + vanilla JS, no framework, no build step)
- **Backend:** [Supabase](https://supabase.com) (hosted PostgreSQL + auth + REST) — free tier
- **Hosting:** GitHub Pages — <https://hemasri-kalaiselvan.github.io/family-tree/>
- **Privacy:** what a visitor can see depends on their role (public / basic member / advanced member / admin)

## What it shows

| Section | What it does | Answers |
|---------|--------------|---------|
| Trees (Vetri · Raj · Sivaraj · Kannaiyan) | Five layouts: Left-right, Top-down, Hourglass, Outline, Linked | "How is everyone related?" |
| Members | One searchable list of everybody | "Who is X?" |
| Events | Birthdays, weddings, memorials and thivasam by month, with a "next 7 days" badge | "What's coming up?" |
| Contacts | Phone numbers, e-mail and social links | "How do I reach them?" |
| Filter | Pick a field (kothram, rasi, star, place…) and a value | "Who shares this?" |
| Person page | Full record, parents, spouses in order, children grouped by partner | "Tell me everything about X" |
| Edit tools (signed-in) | Add, Update, Bulk add, Family editor, CSV import | "Keep the data current" |

### Reading the tree

- **Blue box** = male, **pink box** = female, white = gender not recorded.
- **Number badge** on a box = birth order among siblings.
- **♥** joins a couple. When someone has more than one partner, a small number on the ♥ shows the **spouse order** (1st, 2nd…).
- **Orange box** = the main box of a person who is shown twice; **dashed orange box with ⇄** = the stub. Tap a stub to jump to the main box.
- Women are drawn beside their husband and as a stub under their own parents.
- **Not yet linked** at the bottom lists people who have no parent, spouse or child recorded yet.

## Run it locally

1. Download the repo.
2. Double-click `index.html` — it opens in your browser and connects to Supabase over the internet.

> The Supabase URL and **publishable (anon) key** are embedded in `index.html`.
> That key is designed to be public. What each visitor may read or change is
> controlled in the database (Row Level Security, the `ft_data` read function and
> the `ft_field_access` table) — not by hiding the key.

## Set up the database

In the Supabase SQL Editor, run in order:

1. `sql/01_schema.sql` — tables `ft_trees`, `ft_people`, `ft_marriages`, `ft_field_access`, `ft_app_users`
2. `sql/02_spouse_order.sql` — adds the **spouse order** column for people with more than one partner
3. `sql/03_gender_public.sql` — lets signed-out visitors see gender (needed for the blue / pink boxes)

Then insert your trees (for example `vetri`, `raj`, `sivaraj`, `kannaiyan`) into `ft_trees`.

> The `ft_data` read function that applies the role rules lives in the Supabase
> project; export it from the SQL editor if you want it versioned here.

### Tables

| Table | Holds |
|-------|-------|
| `ft_trees` | The families (key, label, URL slug, sort order) |
| `ft_people` | One row per person: name, gender, father / mother, birth order, dates, kothram, rasi, natchathiram, profession, location, phone, social links, photo, death details (Tamil month, paksha, thithi), placeholder and hidden flags |
| `ft_marriages` | Couples: status (engaged / married / separated / divorced / widowed), engagement and wedding date and place, **spouse order** |
| `ft_field_access` | The minimum role needed to see each column |
| `ft_app_users` | Signed-in users and their role |

## Roles & privacy

| Role | Can do |
|------|--------|
| Public (not signed in) | See the trees and the columns marked `public` |
| `member_basic` | Also see columns marked `member_basic` |
| `member_advanced` | See more columns **and** use the edit tools |
| `admin` | Everything, plus manage trees and users |

Change who sees what by editing `ft_field_access` (one row per table + column).

## Adding & updating people

| Tool | Use it for |
|------|------------|
| Add member | One person at a time, linked to parents / spouse |
| Bulk add | Several people typed in a sheet-style form |
| Family editor | Edit a whole family in one screen |
| Update | Change details of an existing person |
| Import CSV | Paste or load a CSV using the template below |
| Location | Fill in places for many people |

### Bulk import template

Columns: `ref, name, gender, father, mother, spouse, spouse_order, marriage_date, dob, …`

- `ref` is a short label for the row. In `father`, `mother` and `spouse`, type the `ref` of another row, or `#123` for someone already in the app.
- Several spouses: separate with `;` and give the order in `spouse_order` in the same sequence — `spouse = lakshmi;meena`, `spouse_order = 1;2`.
- Leave a cell blank when unknown.

## How AI Helped

- **Claude** — layout design, the tree-drawing logic, responsive menu, SQL scripts, debugging and documentation

## Project structure

```
family-tree/
├── index.html                # the whole app (frontend)
├── README.md                 # this file
└── sql/
    ├── 01_schema.sql         # tables and constraints
    ├── 02_spouse_order.sql   # spouse order for multiple partners
    └── 03_gender_public.sql  # public read access to gender
```

## Tech notes

- **No build step, no framework:** one HTML file; icons are inline SVG so they look the same on every device (older Windows has no colour-emoji font).
- **Responsive header:** tree tabs sit in their own pill group; Members / Events / Contacts / Filter show with labels on a laptop, shrink to icons on a tablet, and move under the ⋮ menu when space runs out.
- **Tree drawing:** each person is drawn once under their own parents; a woman who married in is drawn again beside her husband. A person with several partners keeps them in `spouse_order`, and children are grouped under the correct partner.
- **Scrolling on phones:** the tree grows to its full height so the page scrolls normally; left-right swipes pan inside the tree, and the ⛶ button opens a full-screen pan-and-zoom view.
- **Defensive data loading:** if `spouse_order` or another optional column is missing, the app falls back to record order instead of failing.
