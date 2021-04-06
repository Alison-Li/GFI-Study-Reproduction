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