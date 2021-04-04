-- Dataset: GHTorrent, "2019-06-01"
-- https://t.co/k8Oq1oD8uV?amp=1

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
  AND pl.LANGUAGE = "c"
  OR pl.LANGUAGE = "c++"
GROUP BY
  repo_id,
  p.name
ORDER BY
  num_stars DESC
LIMIT
  500

-- Top 500 most starred repositories in a specified language that satisfies the following:
-- Contains at least 50 issue reports;
-- Has "good first issue" included in its set of label.
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
  AND p.id IN (
  SELECT
    repo_id
  FROM
    `ghtorrentmysql1906.MySQL1906.issues`
  GROUP BY
    repo_id
  HAVING
    COUNT(*) >= 50)
  AND p.id IN (
  SELECT
    repo_id
  FROM
    `ghtorrentmysql1906.MySQL1906.repo_labels`
  WHERE
    name = "good first issue")
GROUP BY
  repo_id,
  p.name
ORDER BY
  num_stars DESC
LIMIT
  500