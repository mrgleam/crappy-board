CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users(
  id uuid PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_verified BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS boards(
  id uuid PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
  owner_id uuid NOT NULL REFERENCES users (id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE TYPE valid_status AS ENUM ('TODO', 'DOING', 'DONE');

CREATE TABLE IF NOT EXISTS tasks(
  id uuid PRIMARY KEY UNIQUE DEFAULT uuid_generate_v4(),
  content VARCHAR(50),
  status valid_status NOT NULL,
  board_id uuid NOT NULL REFERENCES boards (id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS boards_users (
  board_id uuid NOT NULL REFERENCES boards (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT boards_users_pkey PRIMARY KEY (user_id, board_id)
);