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

CREATE TABLE users(
  id uuid DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);