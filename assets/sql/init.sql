-- memo_listテーブル
CREATE TABLE memo_list(
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- SQLiteではINTEGER PRIMARY KEYで自動増分を実現
  name TEXT NOT NULL,                   -- VARCHARはTEXTに変更
  tag INTEGER NOT NULL,                 -- BOOLEANをINTEGERに変更（0 or 1）
  task_order TEXT                       -- JSONはTEXT型として保存
);

-- データ挿入
INSERT INTO memo_list(name, tag, task_order) VALUES
  ('Todoリスト', 1, '{"order": [3,2,1]}'), -- BOOLEANの代わりに1, 0を使用
  ('買い物メモ', 0, '{"order": [4,6,5]}'),
  ('行きたい居酒屋', 0, '{"order": [8,7]}');

-- task_listテーブル
CREATE TABLE task_list(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  memo_id INTEGER NOT NULL,
  complete INTEGER NOT NULL              -- BOOLEANをINTEGERに変更（0 or 1）
);

-- データ挿入
INSERT INTO task_list(name, memo_id, complete) VALUES
  ('タスク０', 1, 0),
  ('タスク１', 1, 0),
  ('タスク２', 1, 0),
  ('タスク３', 2, 1),
  ('タスク４', 2, 0),
  ('タスク５', 2, 1),
  ('タスク６', 3, 0),
  ('タスク７', 3, 1);

-- client_dataテーブル
CREATE TABLE client_data(
  tab INTEGER NOT NULL
);

-- データ挿入
INSERT INTO client_data(tab) VALUES
  (0);

-- memo_orderテーブル
CREATE TABLE memo_order(
  `order` TEXT                           -- JSONをTEXTとして保存
);

-- データ挿入
INSERT INTO memo_order(`order`) VALUES ('{"order": [3,2,1]}');
