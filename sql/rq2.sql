-- RQ2: HOW ARE GFIs SOLVED?

-- Randomly select 13,452 closed issues tagged with non-GFI labels 
-- for forming a comparison dataset.
-- Stored as a view called `non_gfi_issues`
-- Saved as `non_gfi_issues.csv`
SELECT
  i.id,
  i.issue_id AS gh_id,
  rl.name AS label,
  p.repo_id,
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects` p,
  `ghtorrentmysql1906.MySQL1906.issues` i,
  `ghtorrentmysql1906.MySQL1906.issue_labels` il,
  `ghtorrentmysql1906.MySQL1906.issue_events` ie,
  `ghtorrentmysql1906.MySQL1906.repo_labels` rl
WHERE
  p.repo_id = i.repo_id
  AND i.id = il.issue_id
  AND il.label_id = rl.id_
  AND ie.action = "closed"
  AND LOWER(rl.name) NOT IN ("good first issue",
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
ORDER BY
  RAND()
LIMIT
  13452

-- Number of days of resolution
-- Number of developers subscribed to an issue
-- Number of times developers are mentioned in an issue body
-- Number of developers who comment on an issue
-- Number of comments on an issue