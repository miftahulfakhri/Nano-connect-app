-- Nanoconnect App Database Schema
-- PostgreSQL/Supabase Compatible SQL

-- ============================================
-- 1. USER TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS "user" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  user_type VARCHAR(50) NOT NULL CHECK (user_type IN ('admin', 'influencer', 'sme')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_user_type ON "user"(user_type);

-- ============================================
-- 2. INFLUENCER TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS influencer (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  bio TEXT,
  social_media_links JSONB,
  niche VARCHAR(100),
  engagement_rate DECIMAL(5, 2),
  price_per_post DECIMAL(10, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE
);

CREATE INDEX idx_influencer_user_id ON influencer(user_id);
CREATE INDEX idx_influencer_niche ON influencer(niche);

-- ============================================
-- 3. ORDER TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS "order" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  influencer_id UUID NOT NULL,
  sme_id UUID NOT NULL,
  order_status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (order_status IN ('pending', 'completed', 'canceled')),
  total_amount DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (influencer_id) REFERENCES influencer(id) ON DELETE CASCADE,
  FOREIGN KEY (sme_id) REFERENCES "user"(id) ON DELETE CASCADE
);

CREATE INDEX idx_order_influencer_id ON "order"(influencer_id);
CREATE INDEX idx_order_sme_id ON "order"(sme_id);
CREATE INDEX idx_order_status ON "order"(order_status);

-- ============================================
-- 4. REVIEW TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS review (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL UNIQUE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE
);

CREATE INDEX idx_review_order_id ON review(order_id);
CREATE INDEX idx_review_rating ON review(rating);

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Insert sample users
INSERT INTO "user" (id, name, email, password, user_type) VALUES
('550e8400-e29b-41d4-a716-446655440001'::uuid, 'Admin User', 'admin@nanoconnect.com', 'hashed_password_123', 'admin'),
('550e8400-e29b-41d4-a716-446655440002'::uuid, 'Budi Influencer', 'budi@influencer.com', 'hashed_password_456', 'influencer'),
('550e8400-e29b-41d4-a716-446655440003'::uuid, 'Siti SME', 'siti@sme.com', 'hashed_password_789', 'sme'),
('550e8400-e29b-41d4-a716-446655440004'::uuid, 'Rani Influencer', 'rani@influencer.com', 'hashed_password_101', 'influencer'),
('550e8400-e29b-41d4-a716-446655440005'::uuid, 'Hendra SME', 'hendra@sme.com', 'hashed_password_202', 'sme');

-- Insert sample influencers
INSERT INTO influencer (id, user_id, bio, social_media_links, niche, engagement_rate, price_per_post) VALUES
('650e8400-e29b-41d4-a716-446655440001'::uuid, '550e8400-e29b-41d4-a716-446655440002'::uuid, 'Fashion & Lifestyle Enthusiast', '{"instagram": "@budistyle", "tiktok": "@budi_lifestyle"}', 'fashion', 8.5, 5000000),
('650e8400-e29b-41d4-a716-446655440002'::uuid, '550e8400-e29b-41d4-a716-446655440004'::uuid, 'Beauty & Skincare Expert', '{"instagram": "@ranibeauty", "youtube": "Rani Beauty Channel"}', 'beauty', 7.2, 3500000);

-- Insert sample orders
INSERT INTO "order" (id, influencer_id, sme_id, order_status, total_amount) VALUES
('750e8400-e29b-41d4-a716-446655440001'::uuid, '650e8400-e29b-41d4-a716-446655440001'::uuid, '550e8400-e29b-41d4-a716-446655440003'::uuid, 'completed', 5000000),
('750e8400-e29b-41d4-a716-446655440002'::uuid, '650e8400-e29b-41d4-a716-446655440002'::uuid, '550e8400-e29b-41d4-a716-446655440005'::uuid, 'completed', 3500000),
('750e8400-e29b-41d4-a716-446655440003'::uuid, '650e8400-e29b-41d4-a716-446655440001'::uuid, '550e8400-e29b-41d4-a716-446655440003'::uuid, 'pending', 4000000),
('750e8400-e29b-41d4-a716-446655440004'::uuid, '650e8400-e29b-41d4-a716-446655440002'::uuid, '550e8400-e29b-41d4-a716-446655440005'::uuid, 'completed', 2500000),
('750e8400-e29b-41d4-a716-446655440005'::uuid, '650e8400-e29b-41d4-a716-446655440001'::uuid, '550e8400-e29b-41d4-a716-446655440005'::uuid, 'canceled', 5000000);

-- Insert sample reviews
INSERT INTO review (id, order_id, rating, comment) VALUES
('850e8400-e29b-41d4-a716-446655440001'::uuid, '750e8400-e29b-41d4-a716-446655440001'::uuid, 5, 'Excellent campaign! High engagement from followers.'),
('850e8400-e29b-41d4-a716-446655440002'::uuid, '750e8400-e29b-41d4-a716-446655440002'::uuid, 4, 'Good results, professional delivery.'),
('850e8400-e29b-41d4-a716-446655440003'::uuid, '750e8400-e29b-41d4-a716-446655440003'::uuid, 5, 'Outstanding performance! Exceeded expectations.'),
('850e8400-e29b-41d4-a716-446655440004'::uuid, '750e8400-e29b-41d4-a716-446655440004'::uuid, 2, 'Did not meet expectations, low engagement.'),
('850e8400-e29b-41d4-a716-446655440005'::uuid, '750e8400-e29b-41d4-a716-446655440005'::uuid, 4, 'Good work overall, timely delivery.');

