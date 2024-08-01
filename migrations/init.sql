CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE valid_status AS ENUM ('TODO', 'DOING', 'DONE');

CREATE TABLE IF NOT EXISTS tasks(
  id uuid DEFAULT uuid_generate_v4(),
  content VARCHAR(50),
  status valid_status,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users(
  id uuid DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);