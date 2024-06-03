CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE valid_status AS ENUM ('TODO', 'DOING', 'DONE');

CREATE TABLE tasks(
  id uuid DEFAULT uuid_generate_v4(),
  content VARCHAR(50),
  status valid_status,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);
