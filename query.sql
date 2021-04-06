-- DATA COLLECTION:

-- Top 500 most starred repositories in a specified language,
-- e.g. C/C++.
SELECT
  w.repo_id,
  p.name,
  COUNT(*) AS num_stars
FROM
  `ghtorrentmysql1906.MySQL1906.watchers` w,
  `ghtorrentmysql1906.MySQL1906.projects` p,
  `ghtorrentmysql1906.MySQL1906.project_languages` pl
WHERE
  w.repo_id = p.id
  AND p.id = pl.project_id
  AND (pl.language = "c"
  OR pl.language = "c++")
GROUP BY
  repo_id,
  p.name
ORDER BY
  num_stars DESC
LIMIT
  500

-- The top 500 most starred repositories in each of the following languages:
-- Java, JavaScript, C/C++, Python, Ruby, PHP.
-- Stored as a view called `initial_projects`.
(SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "python"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "java"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "javascript"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500 )
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "php"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "ruby"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND (pl.LANGUAGE = "c"
      OR pl.LANGUAGE = "c++")
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)

-- From `initial_projects` view, get all the repositories with at least 50 issues.
-- Stored as a view called `filtered_projects`.
SELECT
  p.repo_id,
  COUNT(*) AS num_issues
FROM
  `gfi-replication-study.gfi_dataset.initial_projects` p,
  `ghtorrentmysql1906.MySQL1906.issues` i
WHERE
  p.repo_id = i.repo_id
GROUP BY
  p.repo_id
HAVING
  COUNT(*) >= 50
ORDER BY
  num_issues

-- From `filtered_projects` view, get all issues tagged with a GFI-synonymous label.
-- Stored as a view called `gfi_issues`.
SELECT
  i.id,
  i.issue_id AS gh_id,
  rl.name AS label,
  p.repo_id,
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects` p,
  `ghtorrentmysql1906.MySQL1906.issues` i,
  `ghtorrentmysql1906.MySQL1906.issue_labels` il,
  `ghtorrentmysql1906.MySQL1906.repo_labels` rl
WHERE
  p.repo_id = i.repo_id
  AND i.id = il.issue_id
  AND il.label_id = rl.id_
  AND LOWER(rl.name) IN ("good first issue",
    "good-first-issue",
    "good first bug",
    "good-first-bug",
    "good first contribution",
    "good first task",
    "minor bug",
    "minor feature",
    "starter bug",
    "easy-pick",
    "easy to fix",
    "low hanging fruit",
    "first timers only",
    "easy",
    "newbie",
    "beginner",
    "beginner-task",
    "up-for-grabs",
    "help wanted (easy)")
  
-- From `gfi_issues`, find issues that have been closed.
-- Saved as `csv/closed_gfi_issues.csv`
SELECT
  *
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` i,
  `ghtorrentmysql1906.MySQL1906.issue_events` ie
WHERE
  i.id = ie.issue_id
  AND ie.action = "closed"

-- Distribution of issues per distinct raw GFI-synonymous label.
-- Saved as `csv/gfi_label_distribution_raw.csv`
SELECT
  i.label AS label,
  COUNT(*) AS num_issues
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` i
GROUP BY
  label
ORDER BY 
  num_issues DESC

-- Distribution of issues per (sanitized) GFI-synonymous label.
-- Similar to previous query but label string is converted to lowercase.
-- Saved as `csv/gfi_label_distribution_lowercase.csv`
SELECT
  LOWER(i.label) AS label,
  COUNT(*) AS num_issues
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` i
GROUP BY
  label
ORDER BY 
  num_issues DESC

-- RQ1: HOW FREQUENTLY DO PROJECTS REPORT GFIs?

-- From `gfi_issues`, find the projects that have at least one GFI-synonymous issue.
-- Saved as `csv/gfi_projects.csv`
SELECT
  DISTINCT repo_id,
  p.name
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` i,
  `ghtorrentmysql1906.MySQL1906.projects` p
WHERE
  i.repo_id = p.id
ORDER BY
  repo_id

-- Number of projects that have used a GFI-synonymous label between 2009 and 2017.
-- Saved as `csv/gfi_projects_year.csv`
SELECT
  EXTRACT(YEAR
  FROM
    i.created_at) AS year,
  COUNT(DISTINCT gfi.repo_id) AS num_projects
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` gfi,
  `ghtorrentmysql1906.MySQL1906.issues` i
WHERE
  gfi.id = i.id
GROUP BY
  year
ORDER BY
  year

-- Number of GFIs per project compared with number of issues per project.
-- Includes the ratio rounded to 2 decimal places.
-- Saved as `csv/gfi_per_project.csv`
SELECT
  gfi.repo_id,
  COUNT(DISTINCT gfi.id) AS num_gfi,
  COUNT(DISTINCT i.id) AS num_issues,
  ROUND(COUNT(DISTINCT gfi.id) / COUNT(DISTINCT i.id), 2) AS ratio
FROM
  `gfi-replication-study.gfi_dataset.gfi_issues` gfi,
  `ghtorrentmysql1906.MySQL1906.issues` i
WHERE
  gfi.repo_id = i.repo_id
GROUP BY
  gfi.repo_id
ORDER BY
  gfi.repo_id

-- Top 40 most starred repositories from `filtered_projects`.
-- Stored as a view called `top_40_filtered_projects`.
SELECT
  p.repo_id,
  COUNT(w.user_id) AS num_stars
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects` p,
  `ghtorrentmysql1906.MySQL1906.watchers` w
WHERE 
  p.repo_id = w.repo_id
GROUP BY
  p.repo_id
ORDER BY
  num_stars DESC
LIMIT 40

-- From the top 40 most starred repositories belonging to the dataset,
-- find the repositories that have reported a GFI.
SELECT
  DISTINCT p.repo_id
FROM
  `gfi-replication-study.gfi_dataset.top_40_filtered_projects` p
WHERE
  p.repo_id IN (
  SELECT
    i.repo_id
  FROM
    `gfi-replication-study.gfi_dataset.gfi_issues` i)

-- Bottom 40 most starred repositories from `filtered_projects`.
-- Stored as a view called `bottom_40_filtered_projects`.
SELECT
  p.repo_id,
  COUNT(w.user_id) AS num_stars
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects` p,
  `ghtorrentmysql1906.MySQL1906.watchers` w
WHERE 
  p.repo_id = w.repo_id
GROUP BY
  p.repo_id
ORDER BY
  num_stars ASC
LIMIT 40

-- From the bottom 40 most starred repositories belonging to the dataset,
-- find the repositories that have reported a GFI.
SELECT
  DISTINCT p.repo_id
FROM
  `gfi-replication-study.gfi_dataset.bottom_40_filtered_projects` p
WHERE
  p.repo_id IN (
  SELECT
    i.repo_id
  FROM
    `gfi-replication-study.gfi_dataset.gfi_issues` i)

-- Project popularity and number of GFIs correlation.
SELECT
  p.repo_id,
  p.num_stars,
  COUNT(DISTINCT i.id) AS num_gfi
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects_popularity` p
LEFT JOIN
  `gfi-replication-study.gfi_dataset.gfi_issues` i
ON
  p.repo_id = i.repo_id
GROUP BY
  p.repo_id,
  p.num_stars
ORDER BY num_stars