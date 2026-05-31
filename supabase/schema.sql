-- La Cha Cha Digital Menu database setup
-- Corrected seed prepared from the screenshots supplied in ChatGPT on 2026-05-29.
-- Run this file inside Supabase SQL Editor for a clean setup.
create extension if not exists pgcrypto;
drop table if exists menu_items cascade;
drop table if exists categories cascade;
drop table if exists delivery_links cascade;
drop table if exists app_users cascade;
drop table if exists settings cascade;

create table settings (
  id int primary key default 1,
  name_en text default 'La cha cha restaurant',
  name_ar text default 'مطعم لا تشا تشا',
  welcome_en text default 'Premium Moroccan-inspired comfort food, grills, pasta, burgers, beverages, coffee and desserts.',
  welcome_ar text default 'أطباق مغربية عصرية، مشويات، باستا، برجر، مشروبات، قهوة وحلويات.',
  logo_url text,
  whatsapp_number text default '+971 3 722 7116',
  phone_number text default '+971 3 722 7116',
  address_en text,
  address_ar text,
  google_maps_url text,
  instagram_url text,
  tiktok_url text,
  snapchat_url text,
  talabat_url text,
  deliveroo_url text,
  careem_url text,
  opening_hours text default '00:00 ~ 23:59',
  currency text default 'AED',
  primary_color text default '#d71920',
  secondary_color text default '#111111',
  footer_en text default 'La Cha Cha Digital Menu',
  footer_ar text default 'قائمة لا تشا تشا الرقمية',
  updated_at timestamptz default now()
);
create table categories (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_ar text,
  sort_order int default 0,
  is_visible boolean default true,
  created_at timestamptz default now()
);
create table menu_items (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references categories(id) on delete set null,
  name_en text not null,
  name_ar text,
  description_en text default '',
  description_ar text default '',
  price numeric(10,2) default 0,
  image_url text,
  label text,
  is_available boolean default true,
  is_visible boolean default true,
  sort_order int default 0,
  created_at timestamptz default now()
);
create table app_users (
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  password_hash text not null,
  role text not null default 'editor' check (role in ('owner','manager','editor','viewer')),
  is_active boolean default true,
  created_at timestamptz default now()
);
create table delivery_links (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  url text,
  is_visible boolean default true,
  sort_order int default 0
);

insert into settings (id) values (1);
insert into app_users (username, password_hash, role, is_active) values ('admin', crypt('123', gen_salt('bf')), 'owner', true);
insert into delivery_links (name, url, is_visible, sort_order) values ('Talabat', null, false, 1);
insert into delivery_links (name, url, is_visible, sort_order) values ('Deliveroo', null, false, 2);
insert into delivery_links (name, url, is_visible, sort_order) values ('Careem', null, false, 3);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Breakfast', 'الإفطار', 1, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'What’s New', 'الجديد', 2, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('c6b13fd1-e3ff-4ef2-8678-747537463ca5', 'Fresh Start', 'بداية منعشة', 3, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('9b46b8ac-c912-40d8-8dd0-b11e71aedfb3', 'Cha Cha Casserole', 'كاسرول تشا تشا', 4, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('7e0c4069-949b-4c69-a36b-835b4fba3ae5', 'Sandwiches and Rolls', 'السندويشات والرولات', 5, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'Crunch and Sear Burgers', 'برجر كرنش آند سير', 6, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Seafood Lover', 'عشاق المأكولات البحرية', 7, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('f5d055f6-4ef8-4a20-90b8-05740dc6a33c', 'Chef’s Grill Selection', 'اختيارات الشيف من المشويات', 8, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Sweet Endings', 'حلويات', 9, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Beverages', 'المشروبات', 10, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'From the Moroccan Table', 'من المائدة المغربية', 11, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'From the Moroccan Oven', 'من الفرن المغربي', 12, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Italian Corner', 'الركن الإيطالي', 13, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('578a1fe7-036b-4948-82b1-764869f72535', 'The Big Melts Collection', 'مجموعة الميلت الكبيرة', 14, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Loaded Collection', 'مجموعة اللودد', 15, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Food Add-ons', 'إضافات الطعام', 16, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Sauce Add-ons', 'إضافات الصوص', 17, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Our Coffee', 'قهوة لا تشا تشا', 18, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Moroccan Style Shakshuka', 'شكشوكة مغربية', 49.00, '/images/items/breakfast-moroccan-style-shakshuka.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'OG Moroccan Batbota', 'بطبوط مغربي أو جي', 29.00, '/images/items/breakfast-og-moroccan-batbota.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Green Halloumi Crunch', 'كرنش حلومي أخضر', 39.00, '/images/items/breakfast-green-halloumi-crunch.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Turkey and Potato Breakfast Roll', 'رول إفطار تركي وبطاطا', 41.60, '/images/items/breakfast-turkey-and-potato-breakfast-roll.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Potato and Pesto Cheese Breakfast Roll', 'رول إفطار بطاطا وجبن بيستو', 32.50, '/images/items/breakfast-potato-and-pesto-cheese-breakfast-roll.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Italian Breakfast Roll', 'رول إفطار إيطالي', 58.50, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Moroccan Breakfast Platter', 'طبق إفطار مغربي', 71.50, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Blue Sky Oats Cereal', 'Blue Sky Oats Cereal', 47.00, null, 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('750b755f-0600-4de9-80fc-673335056ad7', 'Peanut Butter and Berries Oats', 'Peanut Butter and Berries Oats', 47.00, null, 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Caramel Buffalo Tender', 'تندر بافلو بالكراميل', 45.00, '/images/items/what-s-new-caramel-buffalo-tender.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Chili Butter Crispy Shrimp', 'روبيان كرسبي بزبدة التشيلي', 47.00, '/images/items/what-s-new-chili-butter-crispy-shrimp.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Arabic Melt Shawarma', 'شاورما ميلت عربي', 42.00, '/images/items/what-s-new-arabic-melt-shawarma.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Khaltat Rashid Wrap', 'راب خلطة راشد', 39.00, '/images/items/what-s-new-khaltat-rashid-wrap.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Crunch Bomb Wrap', 'راب كرنش بومب', 49.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('5bd20192-13cf-4c0b-b9fa-3ba8ffba66db', 'Dynamite Shrimp', 'دايناميت روبيان', 59.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c6b13fd1-e3ff-4ef2-8678-747537463ca5', 'La Cha Cha Salad', 'سلطة لا تشا تشا', 45.00, '/images/items/fresh-start-la-cha-cha-salad.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c6b13fd1-e3ff-4ef2-8678-747537463ca5', 'Fries', 'Fries', 16.00, null, 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c6b13fd1-e3ff-4ef2-8678-747537463ca5', 'Nashville Tender', 'تندر ناشفيل', 45.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c6b13fd1-e3ff-4ef2-8678-747537463ca5', 'Salad Maghribeia', 'سلطة مغربية', 15.00, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9b46b8ac-c912-40d8-8dd0-b11e71aedfb3', 'Pesto Chicken Casserole', 'كاسرول دجاج بالبيستو', 69.00, '/images/items/cha-cha-casserole-pesto-chicken-casserole.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9b46b8ac-c912-40d8-8dd0-b11e71aedfb3', 'Italian Meatballs Casserole', 'كاسرول كرات اللحم الإيطالية', 71.00, null, 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9b46b8ac-c912-40d8-8dd0-b11e71aedfb3', 'Salmon And Seafood Casserole', 'كاسرول سلمون ومأكولات بحرية', 67.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9b46b8ac-c912-40d8-8dd0-b11e71aedfb3', 'Seafood Casserole', 'كاسرول مأكولات بحرية', 79.00, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7e0c4069-949b-4c69-a36b-835b4fba3ae5', 'S-A Steak Sandwich', 'ساندويتش ستيك S-A', 53.00, '/images/items/sandwiches-and-rolls-s-a-steak-sandwich.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7e0c4069-949b-4c69-a36b-835b4fba3ae5', 'Chicken Fajita Sandwich', 'ساندويتش دجاج فاهيتا', 49.00, null, 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7e0c4069-949b-4c69-a36b-835b4fba3ae5', 'DXB Steak Sandwich', 'ساندويتش ستيك دبي', 53.50, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7e0c4069-949b-4c69-a36b-835b4fba3ae5', 'Pesto Avocado Schnitzel Sandwich', 'ساندويتش شنيتزل أفوكادو وبيستو', 55.45, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'Back to Classic Burger', 'برجر باك تو كلاسيك', 48.00, '/images/items/crunch-and-sear-burgers-back-to-classic-burger.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'The Moroco Crispy Burger', 'برجر موروكو كرسبي', 47.00, '/images/items/crunch-and-sear-burgers-the-moroco-crispy-burger.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', '100 Mile Wagyu Burger', 'برجر واجيو 100 مايل', 51.00, '/images/items/crunch-and-sear-burgers-100-mile-wagyu-burger.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'Black Truffle Wagyu', 'واجيو بالترافل الأسود', 49.00, '/images/items/crunch-and-sear-burgers-black-truffle-wagyu.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'Nashville Heat Burger', 'برجر ناشفيل هيت', 45.00, '/images/items/crunch-and-sear-burgers-nashville-heat-burger.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0328cf1c-e309-4207-846d-cf115253cc01', 'Ultimate Chicken Burger', 'برجر دجاج ألتميت', 43.00, '/images/items/crunch-and-sear-burgers-ultimate-chicken-burger.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Salsa Crispy Fish Fillet', 'فيليه سمك كرسبي بالسالسا', 57.00, '/images/items/seafood-lover-salsa-crispy-fish-fillet.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Moroccan Fish Tagine', 'طاجن سمك مغربي', 62.00, '/images/items/seafood-lover-moroccan-fish-tagine.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Salmon Seafood Casserole', 'كاسرول سلمون ومأكولات بحرية', 65.00, '/images/items/seafood-lover-salmon-seafood-casserole.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'The Shrimp Heat Different', 'روبيان هيت ديفرنت', 65.00, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Cilantro Grilled Salmon', 'سلمون مشوي بالكزبرة', 65.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9437210a-6fe4-46b9-91f1-dd334a2d734b', 'Garlic Chimichurri Grilled Shrimp', 'روبيان مشوي بالثوم والتشيميتشوري', 72.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f5d055f6-4ef8-4a20-90b8-05740dc6a33c', 'S-A Steak', 'ستيك S-A', 132.00, '/images/items/chef-s-grill-selection-s-a-steak.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f5d055f6-4ef8-4a20-90b8-05740dc6a33c', 'Moroccan Grilled Chicken', 'دجاج مغربي مشوي', 59.50, '/images/items/chef-s-grill-selection-moroccan-grilled-chicken.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f5d055f6-4ef8-4a20-90b8-05740dc6a33c', 'Egg & Steak Perfection', 'إج آند ستيك بيرفكشن', 126.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f5d055f6-4ef8-4a20-90b8-05740dc6a33c', 'Peri Peri Grilled Chicken', 'دجاج مشوي بيري بيري', 55.50, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Kunafa with Cream and Cheese', 'كنافة بالكريمة والجبن', 45.00, '/images/items/sweet-endings-kunafa-with-cream-and-cheese.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Chocolate Cheese Kunafa', 'كنافة شوكولاتة بالجبن', 45.00, '/images/items/sweet-endings-chocolate-cheese-kunafa.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Signature Tiramissu', 'تيراميسو سيغنتشر', 37.00, '/images/items/sweet-endings-signature-tiramissu.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Pistachio Matcha Tiramissu', 'تيراميسو ماتشا بالفستق', 35.00, '/images/items/sweet-endings-pistachio-matcha-tiramissu.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('9e10a5f7-686a-4604-b5bb-8cce9e0ecff7', 'Classic Tiramissu', 'تيراميسو كلاسيك', 29.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Midnight Blue Mojito', 'موهيتو ميدنايت بلو', 29.00, '/images/items/beverages-midnight-blue-mojito.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Signature Cuban Mojito', 'موهيتو كوبي سيغنتشر', 25.00, '/images/items/beverages-signature-cuban-mojito.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Island Heat Mojito', 'موهيتو آيلاند هيت', 29.00, '/images/items/beverages-island-heat-mojito.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Strawberry Smooth Mojito', 'موهيتو فراولة سموث', 29.00, '/images/items/beverages-strawberry-smooth-mojito.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Passion Bliss Juice', 'عصير باشن بليس', 19.45, '/images/items/beverages-passion-bliss-juice.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Hibiscus Iced Tea', 'شاي كركديه مثلج', 36.75, '/images/items/beverages-hibiscus-iced-tea.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Fresh Orange Juice', 'عصير برتقال طازج', 19.45, '/images/items/beverages-fresh-orange-juice.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Moroccan Tea', 'شاي مغربي', 2.00, '/images/items/beverages-moroccan-tea.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Still Water', 'مياه عادية', 5.00, '/images/items/beverages-still-water.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Sparkling Water', 'مياه غازية', 8.00, '/images/items/beverages-sparkling-water.jpg', 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Soda Zero', 'Soda Zero', 8.00, null, 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Pepsi 330ml', 'Pepsi 330ml', 8.00, null, 12, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Sprite', 'Sprite', 8.00, null, 13, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Coca Cola 245ml', 'Coca Cola 245ml', 8.00, null, 14, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Kinza Cola', 'Kinza Cola', 12.00, null, 15, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Kinza Lemon', 'Kinza Lemon', 12.00, null, 16, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Kinza Pomegranate', 'كينزا رمان', 12.00, null, 17, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Kinza Blackcurrant', 'كينزا بلاك كرانت', 12.00, null, 18, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8480b2bc-03ad-4e1c-8796-8b06c284a595', 'Soft Drink', 'مشروب غازي', 8.00, null, 19, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Chicken Tajine with Olives', 'طاجن دجاج بالزيتون', 67.00, '/images/items/from-the-moroccan-table-chicken-tajine-with-olives.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Harira Soup', 'شوربة حريرة', 29.00, '/images/items/from-the-moroccan-table-harira-soup.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Chicken Tajine with Vegetables and Olives', 'طاجن دجاج بالخضار والزيتون', 67.00, '/images/items/from-the-moroccan-table-chicken-tajine-with-vegetables-and-olives.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Tanjia Marrakeshia', 'طنجية مراكشية', 62.00, '/images/items/from-the-moroccan-table-tanjia-marrakeshia.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Tajine with Prunes', 'طاجن بالبرقوق', 62.00, '/images/items/from-the-moroccan-table-tajine-with-prunes.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Seafood Pastilla', 'بسطيلة مأكولات بحرية', 49.00, '/images/items/from-the-moroccan-table-seafood-pastilla.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('fae08e63-b2db-4576-aab9-4a7708b769e1', 'Chicken and Almond Pastilla', 'بسطيلة دجاج ولوز', 47.00, '/images/items/from-the-moroccan-table-chicken-and-almond-pastilla.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Moroccan Meloui', 'ملوي مغربي', 18.90, '/images/items/from-the-moroccan-oven-moroccan-meloui.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen with Beef', 'مسمن باللحم', 35.45, '/images/items/from-the-moroccan-oven-msemen-with-beef.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen BL Shahma', 'مسمن بالشحمة', 33.10, '/images/items/from-the-moroccan-oven-msemen-bl-shahma.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Moroccan Msemen', 'مسمن مغربي', 18.00, '/images/items/from-the-moroccan-oven-moroccan-msemen.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Moroccan Batbota [2pc]', 'بطبوط مغربي [قطعتان]', 14.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen Cheesy Oman Crunch', 'مسمن تشيزي عمان كرنش', 38.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen Amlou & Date Bliss', 'مسمن أملو وتمر', 39.00, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen Golden Honey Almond', 'مسمن عسل ذهبي ولوز', 38.00, null, 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen Chocolate Kunafa Pistachio', 'مسمن شوكولاتة كنافة وفستق', 39.00, null, 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('8c6d3c2a-b23c-42bc-a23f-4b167e14288c', 'Msemen Green Morning', 'مسمن جرين مورنينغ', 39.00, null, 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Quattro Creamy Pasta', 'باستا كواترو كريمية', 54.00, '/images/items/italian-corner-quattro-creamy-pasta.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Arrabiata Pasta', 'باستا أرابياتا', 49.00, '/images/items/italian-corner-arrabiata-pasta.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Truffle Pasta', 'باستا ترافل', 49.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Seafood Lemon Pasta', 'باستا ليمون بالمأكولات البحرية', 53.55, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'The Pesto Chicken Pasta', 'باستا دجاج بالبيستو', 52.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3af25b54-0074-40ef-886c-0a26728967d7', 'Steak Pasta', 'باستا ستيك', 55.65, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('578a1fe7-036b-4948-82b1-764869f72535', 'Angus BIG Melt', 'أنجوس بيج ميلت', 55.40, '/images/items/the-big-melts-collection-angus-big-melt.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('578a1fe7-036b-4948-82b1-764869f72535', 'Crispy Big Melt Chicken', 'كرسبي بيج ميلت دجاج', 49.00, null, 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('578a1fe7-036b-4948-82b1-764869f72535', 'Big Melt Shrimp', 'بيج ميلت روبيان', 49.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Loaded Sweet Potato (Beef)', 'بطاطا حلوة لودد باللحم', 48.60, '/images/items/loaded-collection-loaded-sweet-potato-beef.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Loaded Sweet Potato (Chicken)', 'بطاطا حلوة لودد بالدجاج', 47.50, '/images/items/loaded-collection-loaded-sweet-potato-chicken.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Loaded Sweet Potato (Vegetable)', 'بطاطا حلوة لودد بالخضار', 38.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Italian Frites', 'Italian Frites', 26.25, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Cheese, Bacon, and Pickles', 'جبن وبيكن ومخلل', 32.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Loaded Nashville Fries', 'بطاطس ناشفيل لودد', 43.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e8258-87e5-4a54-9e35-fdccced310d1', 'Classic Loaded Fries', 'بطاطس لودد كلاسيك', 37.80, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Cheese', 'Extra Cheese', 5.00, '/images/items/food-add-ons-extra-cheese.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Swiss Cheese', 'Swiss Cheese', 4.00, '/images/items/food-add-ons-swiss-cheese.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Parmesan Cheese', 'Parmesan Cheese', 4.00, '/images/items/food-add-ons-parmesan-cheese.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Crispy Bacon', 'Crispy Bacon', 7.00, '/images/items/food-add-ons-crispy-bacon.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Caramelized Onion', 'Caramelized Onion', 4.00, '/images/items/food-add-ons-caramelized-onion.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Grilled Mushrooms', 'Grilled Mushrooms', 4.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Jalapeno', 'Jalapeno', 3.00, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Protein Chicken', 'Extra Protein Chicken', 6.00, null, 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Protein Shrimp', 'Extra Protein Shrimp', 12.00, null, 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Steak', 'Extra Steak', 12.00, null, 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Feta Cheese', 'Feta Cheese', 4.00, null, 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Crispy Chicken 50 Gram', 'دجاج كرسبي إضافي 50 غرام', 5.00, null, 12, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Crispy Shrimp 50 Gram', 'روبيان كرسبي إضافي 50 غرام', 7.00, null, 13, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Extra Angus Beef Patty 100 Gram', 'قطعة برجر أنجوس إضافية 100 غرام', 25.00, null, 14, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Green Salad Side Dish', 'سلطة خضراء جانبية', 5.00, null, 15, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Cheese Cajun Fries', 'بطاطس كاجن بالجبن', 16.00, null, 16, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('25ea2de6-f393-4105-975d-f2b01ce9b359', 'Potato Wedges', 'بطاطس ودجز', 8.00, null, 17, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Caesar Sauce', 'Caesar Sauce', 4.00, '/images/items/sauce-add-ons-caesar-sauce.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Signature Sauce', 'Signature Sauce', 4.00, '/images/items/sauce-add-ons-signature-sauce.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Cheese Sauce', 'Cheese Sauce', 4.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Spicy Cajun Sauce', 'Spicy Cajun Sauce', 4.00, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Fajita White Sauce', 'Fajita White Sauce', 4.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Pesto Sauce', 'Pesto Sauce', 4.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Balsamic Sauce', 'Balsamic Sauce', 4.00, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Extra Quattro Sauce', 'Extra Quattro Sauce', 4.00, null, 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Extra Truffle Sauce', 'Extra Truffle Sauce', 4.00, null, 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Extra Italian Arrabiata Sauce', 'Extra Italian Arrabiata Sauce', 3.00, null, 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('af629dee-84b0-4a6f-b696-b85bf70c02b3', 'Extra Salsa', 'Extra Salsa', 3.00, null, 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Espresso', 'Espresso', 12.00, '/images/items/our-coffee-espresso.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Flat White', 'Flat White', 16.00, '/images/items/our-coffee-flat-white.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'White Mocha Latte', 'White Mocha Latte', 16.00, null, 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Iced Date Cloud', 'آيسد ديت كلاود', 37.00, null, 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Coffee Brown Caramel Latte', 'لاتيه براون كراميل', 35.00, null, 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Iced Tiramissu Latte', 'آيسد تيراميسو لاتيه', 35.00, null, 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Cappuccino', 'Cappuccino', 19.00, null, 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('d9fb03b0-3a1f-49a2-b6af-24178fd91934', 'Americano Classic', 'أمريكانو كلاسيك', 16.00, null, 8, true, true);

-- Extra fields for homepage hero background and discount system
alter table settings add column if not exists hero_image_url text;
alter table menu_items add column if not exists discount_percent numeric(5,2) default 0;
update menu_items set discount_percent = 0 where discount_percent is null;
