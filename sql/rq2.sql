-- RQ2: HOW ARE GFIs SOLVED?

-- Randomly select 13,452 closed issues tagged with non-GFI labels 
-- for forming a comparison dataset.
-- Stored as a view called `closed_non_gfi_issues`
-- Saved as `closed_non_gfi_issues.csv`
SELECT
  p.repo_id,
  i.id
FROM
  `gfi-replication-study.gfi_dataset.filtered_projects` p,
  `ghtorrentmysql1906.MySQL1906.issues` i,
  `ghtorrentmysql1906.MySQL1906.issue_events` ie
WHERE
  p.repo_id = i.repo_id
  AND i.id = ie.issue_id
  AND ie.action = "closed"
  AND i.id NOT IN (SELECT id FROM `gfi-replication-study.gfi_dataset.gfi_issues`)
ORDER BY
  RAND()
LIMIT
  13452

-- The following set of queries are for collecting statistics for the GFI and non-GFIs using the 
-- datasets stored in the views `closed_gfi_issues` and `closed_non_gfi_issues`
-- Replace the corresponding table name in the query for getting the result set for either.

-- Number of days of resolution for a GFI.

-- Number of developers subscribed to a GFI.
SELECT
  i.id,
  COUNT(DISTINCT ie.actor_id) AS num_subscribed
FROM
  `gfi-replication-study.gfi_dataset.closed_gfi_issues` i
INNER JOIN
  `ghtorrentmysql1906.MySQL1906.issue_events` ie
ON
  i.id = ie.issue_id
WHERE
  ie.action = "subscribed"
GROUP BY
  i.id

-- Number of times developers are mentioned in GFI body

-- Number of developers who comment on each GFI and number of comments on each GFI.
SELECT
  i.id,
  COUNT(DISTINCT ic.user_id) AS num_devs,
  COUNT(ic.comment_id) AS num_comments
FROM
  `gfi-replication-study.gfi_dataset.closed_gfi_issues` i
INNER JOIN
  `ghtorrentmysql1906.MySQL1906.issue_comments` ic
ON
  i.id = ic.issue_id
GROUP BY
  i.id