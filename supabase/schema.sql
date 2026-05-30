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
-- Default admin is created automatically by the app on first login with username admin and password 123.
insert into delivery_links (name, url, is_visible, sort_order) values ('Talabat', null, false, 1);
insert into delivery_links (name, url, is_visible, sort_order) values ('Deliveroo', null, false, 2);
insert into delivery_links (name, url, is_visible, sort_order) values ('Careem', null, false, 3);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Breakfast', 'الإفطار', 1, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'What’s New', 'الجديد', 2, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('476ae997-c7cf-423a-90d3-9180ed0dac94', 'Fresh Start', 'بداية منعشة', 3, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('7ed71af2-ee3a-4a95-b6e3-180777f10367', 'Cha Cha Casserole', 'كاسرول تشا تشا', 4, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('c0063f85-bbfc-4082-b446-ce18f576ec5d', 'Sandwiches and Rolls', 'السندويشات والرولات', 5, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'Crunch and Sear Burgers', 'برجر كرنش آند سير', 6, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Seafood Lover', 'عشاق المأكولات البحرية', 7, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('ec16708e-15fb-4636-9252-e1a61403d497', 'Chef’s Grill Selection', 'اختيارات الشيف من المشويات', 8, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Sweet Endings', 'حلويات', 9, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Beverages', 'المشروبات', 10, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'From the Moroccan Table', 'من المائدة المغربية', 11, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'From the Moroccan Oven', 'من الفرن المغربي', 12, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Italian Corner', 'الركن الإيطالي', 13, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('84d96160-9ae2-4648-ae05-281fa315939f', 'The Big Melts Collection', 'مجموعة الميلت الكبيرة', 14, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Loaded Collection', 'مجموعة اللودد', 15, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Food Add-ons', 'إضافات الطعام', 16, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Sauce Add-ons', 'إضافات الصوص', 17, true);
insert into categories (id, name_en, name_ar, sort_order, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Our Coffee', 'قهوة لا تشا تشا', 18, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Moroccan Style Shakshuka', 'شكشوكة مغربية', 49.00, '/images/items/breakfast-moroccan-style-shakshuka.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'OG Moroccan Batbota', 'بطبوط مغربي أو جي', 29.00, '/images/items/breakfast-og-moroccan-batbota.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Green Halloumi Crunch', 'كرنش حلومي أخضر', 39.00, '/images/items/breakfast-green-halloumi-crunch.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Turkey and Potato Breakfast Roll', 'رول إفطار تركي وبطاطا', 41.60, '/images/items/breakfast-turkey-and-potato-breakfast-roll.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Potato and Pesto Cheese Breakfast Roll', 'رول إفطار بطاطا وجبن بيستو', 32.50, '/images/items/breakfast-potato-and-pesto-cheese-breakfast-roll.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Italian Breakfast Roll', 'رول إفطار إيطالي', 58.50, '/images/items/breakfast-italian-breakfast-roll.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Moroccan Breakfast Platter', 'طبق إفطار مغربي', 71.50, '/images/items/breakfast-moroccan-breakfast-platter.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Blue Sky Oats Cereal', 'Blue Sky Oats Cereal', 47.00, '/images/items/breakfast-blue-sky-oats-cereal.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('a728e80f-6d60-4f6c-9220-b190098bc87c', 'Peanut Butter and Berries Oats', 'Peanut Butter and Berries Oats', 47.00, '/images/items/breakfast-peanut-butter-and-berries-oats.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Caramel Buffalo Tender', 'تندر بافلو بالكراميل', 45.00, '/images/items/what-s-new-caramel-buffalo-tender.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Chili Butter Crispy Shrimp', 'روبيان كرسبي بزبدة التشيلي', 47.00, '/images/items/what-s-new-chili-butter-crispy-shrimp.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Arabic Melt Shawarma', 'شاورما ميلت عربي', 42.00, '/images/items/what-s-new-arabic-melt-shawarma.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Khaltat Rashid Wrap', 'راب خلطة راشد', 39.00, '/images/items/what-s-new-khaltat-rashid-wrap.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Crunch Bomb Wrap', 'راب كرنش بومب', 49.00, '/images/items/what-s-new-crunch-bomb-wrap.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('95c53ada-5e48-4377-afbd-73bef21fb06f', 'Dynamite Shrimp', 'دايناميت روبيان', 59.00, '/images/items/what-s-new-dynamite-shrimp.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('476ae997-c7cf-423a-90d3-9180ed0dac94', 'La Cha Cha Salad', 'سلطة لا تشا تشا', 45.00, '/images/items/fresh-start-la-cha-cha-salad.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('476ae997-c7cf-423a-90d3-9180ed0dac94', 'Fries', 'Fries', 16.00, '/images/items/fresh-start-fries.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('476ae997-c7cf-423a-90d3-9180ed0dac94', 'Nashville Tender', 'تندر ناشفيل', 45.00, '/images/items/fresh-start-nashville-tender.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('476ae997-c7cf-423a-90d3-9180ed0dac94', 'Salad Maghribeia', 'سلطة مغربية', 15.00, '/images/items/fresh-start-salad-maghribeia.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7ed71af2-ee3a-4a95-b6e3-180777f10367', 'Pesto Chicken Casserole', 'كاسرول دجاج بالبيستو', 69.00, '/images/items/cha-cha-casserole-pesto-chicken-casserole.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7ed71af2-ee3a-4a95-b6e3-180777f10367', 'Italian Meatballs Casserole', 'كاسرول كرات اللحم الإيطالية', 71.00, '/images/items/cha-cha-casserole-italian-meatballs-casserole.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7ed71af2-ee3a-4a95-b6e3-180777f10367', 'Salmon And Seafood Casserole', 'كاسرول سلمون ومأكولات بحرية', 67.00, '/images/items/cha-cha-casserole-salmon-and-seafood-casserole.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('7ed71af2-ee3a-4a95-b6e3-180777f10367', 'Seafood Casserole', 'كاسرول مأكولات بحرية', 79.00, '/images/items/cha-cha-casserole-seafood-casserole.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c0063f85-bbfc-4082-b446-ce18f576ec5d', 'S-A Steak Sandwich', 'ساندويتش ستيك S-A', 53.00, '/images/items/sandwiches-and-rolls-s-a-steak-sandwich.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c0063f85-bbfc-4082-b446-ce18f576ec5d', 'Chicken Fajita Sandwich', 'ساندويتش دجاج فاهيتا', 49.00, '/images/items/sandwiches-and-rolls-chicken-fajita-sandwich.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c0063f85-bbfc-4082-b446-ce18f576ec5d', 'DXB Steak Sandwich', 'ساندويتش ستيك دبي', 53.50, '/images/items/sandwiches-and-rolls-dxb-steak-sandwich.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('c0063f85-bbfc-4082-b446-ce18f576ec5d', 'Pesto Avocado Schnitzel Sandwich', 'ساندويتش شنيتزل أفوكادو وبيستو', 55.45, '/images/items/sandwiches-and-rolls-pesto-avocado-schnitzel-sandwich.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'Back to Classic Burger', 'برجر باك تو كلاسيك', 48.00, '/images/items/crunch-and-sear-burgers-back-to-classic-burger.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'The Moroco Crispy Burger', 'برجر موروكو كرسبي', 47.00, '/images/items/crunch-and-sear-burgers-the-moroco-crispy-burger.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', '100 Mile Wagyu Burger', 'برجر واجيو 100 مايل', 51.00, '/images/items/crunch-and-sear-burgers-100-mile-wagyu-burger.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'Black Truffle Wagyu', 'واجيو بالترافل الأسود', 49.00, '/images/items/crunch-and-sear-burgers-black-truffle-wagyu.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'Nashville Heat Burger', 'برجر ناشفيل هيت', 45.00, '/images/items/crunch-and-sear-burgers-nashville-heat-burger.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('30c0dffd-dd1c-459a-8193-53c7629fac78', 'Ultimate Chicken Burger', 'برجر دجاج ألتميت', 43.00, '/images/items/crunch-and-sear-burgers-ultimate-chicken-burger.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Salsa Crispy Fish Fillet', 'فيليه سمك كرسبي بالسالسا', 57.00, '/images/items/seafood-lover-salsa-crispy-fish-fillet.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Moroccan Fish Tagine', 'طاجن سمك مغربي', 62.00, '/images/items/seafood-lover-moroccan-fish-tagine.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Salmon Seafood Casserole', 'كاسرول سلمون ومأكولات بحرية', 65.00, '/images/items/seafood-lover-salmon-seafood-casserole.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'The Shrimp Heat Different', 'روبيان هيت ديفرنت', 65.00, '/images/items/seafood-lover-the-shrimp-heat-different.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Cilantro Grilled Salmon', 'سلمون مشوي بالكزبرة', 65.00, '/images/items/seafood-lover-cilantro-grilled-salmon.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('0798450d-2ed1-49c4-a560-f2241660e26c', 'Garlic Chimichurri Grilled Shrimp', 'روبيان مشوي بالثوم والتشيميتشوري', 72.00, '/images/items/seafood-lover-garlic-chimichurri-grilled-shrimp.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ec16708e-15fb-4636-9252-e1a61403d497', 'S-A Steak', 'ستيك S-A', 132.00, '/images/items/chef-s-grill-selection-s-a-steak.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ec16708e-15fb-4636-9252-e1a61403d497', 'Moroccan Grilled Chicken', 'دجاج مغربي مشوي', 59.50, '/images/items/chef-s-grill-selection-moroccan-grilled-chicken.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ec16708e-15fb-4636-9252-e1a61403d497', 'Egg & Steak Perfection', 'إج آند ستيك بيرفكشن', 126.00, '/images/items/chef-s-grill-selection-egg-and-steak-perfection.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ec16708e-15fb-4636-9252-e1a61403d497', 'Peri Peri Grilled Chicken', 'دجاج مشوي بيري بيري', 55.50, '/images/items/chef-s-grill-selection-peri-peri-grilled-chicken.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Kunafa with Cream and Cheese', 'كنافة بالكريمة والجبن', 45.00, '/images/items/sweet-endings-kunafa-with-cream-and-cheese.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Chocolate Cheese Kunafa', 'كنافة شوكولاتة بالجبن', 45.00, '/images/items/sweet-endings-chocolate-cheese-kunafa.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Signature Tiramissu', 'تيراميسو سيغنتشر', 37.00, '/images/items/sweet-endings-signature-tiramissu.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Pistachio Matcha Tiramissu', 'تيراميسو ماتشا بالفستق', 35.00, '/images/items/sweet-endings-pistachio-matcha-tiramissu.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('66aa7a26-ae08-4bc9-9b27-4f61c66cc335', 'Classic Tiramissu', 'تيراميسو كلاسيك', 29.00, '/images/items/sweet-endings-classic-tiramissu.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Midnight Blue Mojito', 'موهيتو ميدنايت بلو', 29.00, '/images/items/beverages-midnight-blue-mojito.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Signature Cuban Mojito', 'موهيتو كوبي سيغنتشر', 25.00, '/images/items/beverages-signature-cuban-mojito.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Island Heat Mojito', 'موهيتو آيلاند هيت', 29.00, '/images/items/beverages-island-heat-mojito.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Strawberry Smooth Mojito', 'موهيتو فراولة سموث', 29.00, '/images/items/beverages-strawberry-smooth-mojito.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Passion Bliss Juice', 'عصير باشن بليس', 19.45, '/images/items/beverages-passion-bliss-juice.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Hibiscus Iced Tea', 'شاي كركديه مثلج', 36.75, '/images/items/beverages-hibiscus-iced-tea.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Fresh Orange Juice', 'عصير برتقال طازج', 19.45, '/images/items/beverages-fresh-orange-juice.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Moroccan Tea', 'شاي مغربي', 2.00, '/images/items/beverages-moroccan-tea.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Still Water', 'مياه عادية', 5.00, '/images/items/beverages-still-water.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Sparkling Water', 'مياه غازية', 8.00, '/images/items/beverages-sparkling-water.jpg', 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Soda Zero', 'Soda Zero', 8.00, '/images/items/beverages-soda-zero.jpg', 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Pepsi 330ml', 'Pepsi 330ml', 8.00, '/images/items/beverages-pepsi-330ml.jpg', 12, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Sprite', 'Sprite', 8.00, '/images/items/beverages-sprite.jpg', 13, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Coca Cola 245ml', 'Coca Cola 245ml', 8.00, '/images/items/beverages-coca-cola-245ml.jpg', 14, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Kinza Cola', 'Kinza Cola', 12.00, '/images/items/beverages-kinza-cola.jpg', 15, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Kinza Lemon', 'Kinza Lemon', 12.00, '/images/items/beverages-kinza-lemon.jpg', 16, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Kinza Pomegranate', 'كينزا رمان', 12.00, '/images/items/beverages-kinza-pomegranate.jpg', 17, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Kinza Blackcurrant', 'كينزا بلاك كرانت', 12.00, null, 18, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('ab9bb8c7-f5d1-4123-ac77-d85d85e47358', 'Soft Drink', 'مشروب غازي', 8.00, '/images/items/beverages-soft-drink.jpg', 19, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Chicken Tajine with Olives', 'طاجن دجاج بالزيتون', 67.00, '/images/items/from-the-moroccan-table-chicken-tajine-with-olives.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Harira Soup', 'شوربة حريرة', 29.00, '/images/items/from-the-moroccan-table-harira-soup.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Chicken Tajine with Vegetables and Olives', 'طاجن دجاج بالخضار والزيتون', 67.00, '/images/items/from-the-moroccan-table-chicken-tajine-with-vegetables-and-olives.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Tanjia Marrakeshia', 'طنجية مراكشية', 62.00, '/images/items/from-the-moroccan-table-tanjia-marrakeshia.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Tajine with Prunes', 'طاجن بالبرقوق', 62.00, '/images/items/from-the-moroccan-table-tajine-with-prunes.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Seafood Pastilla', 'بسطيلة مأكولات بحرية', 49.00, '/images/items/from-the-moroccan-table-seafood-pastilla.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('2729368a-3557-40d6-b734-11aa52f77e7f', 'Chicken and Almond Pastilla', 'بسطيلة دجاج ولوز', 47.00, '/images/items/from-the-moroccan-table-chicken-and-almond-pastilla.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Moroccan Meloui', 'ملوي مغربي', 18.90, '/images/items/from-the-moroccan-oven-moroccan-meloui.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen with Beef', 'مسمن باللحم', 35.45, '/images/items/from-the-moroccan-oven-msemen-with-beef.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen BL Shahma', 'مسمن بالشحمة', 33.10, '/images/items/from-the-moroccan-oven-msemen-bl-shahma.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Moroccan Msemen', 'مسمن مغربي', 18.00, '/images/items/from-the-moroccan-oven-moroccan-msemen.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Moroccan Batbota [2pc]', 'بطبوط مغربي [قطعتان]', 14.00, '/images/items/from-the-moroccan-oven-moroccan-batbota-2pc.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen Cheesy Oman Crunch', 'مسمن تشيزي عمان كرنش', 38.00, '/images/items/from-the-moroccan-oven-msemen-cheesy-oman-crunch.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen Amlou & Date Bliss', 'مسمن أملو وتمر', 39.00, '/images/items/from-the-moroccan-oven-msemen-amlou-and-date-bliss.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen Golden Honey Almond', 'مسمن عسل ذهبي ولوز', 38.00, '/images/items/from-the-moroccan-oven-msemen-golden-honey-almond.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen Chocolate Kunafa Pistachio', 'مسمن شوكولاتة كنافة وفستق', 39.00, '/images/items/from-the-moroccan-oven-msemen-chocolate-kunafa-pistachio.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('f98e988e-8dea-4978-910c-326796ad0052', 'Msemen Green Morning', 'مسمن جرين مورنينغ', 39.00, '/images/items/from-the-moroccan-oven-msemen-green-morning.jpg', 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Quattro Creamy Pasta', 'باستا كواترو كريمية', 54.00, '/images/items/italian-corner-quattro-creamy-pasta.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Arrabiata Pasta', 'باستا أرابياتا', 49.00, '/images/items/italian-corner-arrabiata-pasta.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Truffle Pasta', 'باستا ترافل', 49.00, '/images/items/italian-corner-truffle-pasta.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Seafood Lemon Pasta', 'باستا ليمون بالمأكولات البحرية', 53.55, '/images/items/italian-corner-seafood-lemon-pasta.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'The Pesto Chicken Pasta', 'باستا دجاج بالبيستو', 52.00, '/images/items/italian-corner-the-pesto-chicken-pasta.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('356222e4-1053-4f13-b3c3-498c1fac86d6', 'Steak Pasta', 'باستا ستيك', 55.65, '/images/items/italian-corner-steak-pasta.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('84d96160-9ae2-4648-ae05-281fa315939f', 'Angus BIG Melt', 'أنجوس بيج ميلت', 55.40, '/images/items/the-big-melts-collection-angus-big-melt.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('84d96160-9ae2-4648-ae05-281fa315939f', 'Crispy Big Melt Chicken', 'كرسبي بيج ميلت دجاج', 49.00, '/images/items/the-big-melts-collection-crispy-big-melt-chicken.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('84d96160-9ae2-4648-ae05-281fa315939f', 'Big Melt Shrimp', 'بيج ميلت روبيان', 49.00, '/images/items/the-big-melts-collection-big-melt-shrimp.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Loaded Sweet Potato (Beef)', 'بطاطا حلوة لودد باللحم', 48.60, '/images/items/loaded-collection-loaded-sweet-potato-beef.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Loaded Sweet Potato (Chicken)', 'بطاطا حلوة لودد بالدجاج', 47.50, '/images/items/loaded-collection-loaded-sweet-potato-chicken.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Loaded Sweet Potato (Vegetable)', 'بطاطا حلوة لودد بالخضار', 38.00, '/images/items/loaded-collection-loaded-sweet-potato-vegetable.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Italian Frites', 'Italian Frites', 26.25, '/images/items/loaded-collection-italian-frites.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Cheese, Bacon, and Pickles', 'جبن وبيكن ومخلل', 32.00, '/images/items/loaded-collection-cheese-bacon-and-pickles.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Loaded Nashville Fries', 'بطاطس ناشفيل لودد', 43.00, '/images/items/loaded-collection-loaded-nashville-fries.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('209b3a2d-9d87-4c10-82b9-4351403c519c', 'Classic Loaded Fries', 'بطاطس لودد كلاسيك', 37.80, '/images/items/loaded-collection-classic-loaded-fries.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Cheese', 'Extra Cheese', 5.00, '/images/items/food-add-ons-extra-cheese.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Swiss Cheese', 'Swiss Cheese', 4.00, '/images/items/food-add-ons-swiss-cheese.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Parmesan Cheese', 'Parmesan Cheese', 4.00, '/images/items/food-add-ons-parmesan-cheese.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Crispy Bacon', 'Crispy Bacon', 7.00, '/images/items/food-add-ons-crispy-bacon.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Caramelized Onion', 'Caramelized Onion', 4.00, '/images/items/food-add-ons-caramelized-onion.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Grilled Mushrooms', 'Grilled Mushrooms', 4.00, '/images/items/food-add-ons-grilled-mushrooms.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Jalapeno', 'Jalapeno', 3.00, '/images/items/food-add-ons-jalapeno.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Protein Chicken', 'Extra Protein Chicken', 6.00, '/images/items/food-add-ons-extra-protein-chicken.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Protein Shrimp', 'Extra Protein Shrimp', 12.00, '/images/items/food-add-ons-extra-protein-shrimp.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Steak', 'Extra Steak', 12.00, '/images/items/food-add-ons-extra-steak.jpg', 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Feta Cheese', 'Feta Cheese', 4.00, '/images/items/food-add-ons-feta-cheese.jpg', 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Crispy Chicken 50 Gram', 'دجاج كرسبي إضافي 50 غرام', 5.00, '/images/items/food-add-ons-extra-crispy-chicken-50-gram.jpg', 12, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Crispy Shrimp 50 Gram', 'روبيان كرسبي إضافي 50 غرام', 7.00, '/images/items/food-add-ons-extra-crispy-shrimp-50-gram.jpg', 13, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Extra Angus Beef Patty 100 Gram', 'قطعة برجر أنجوس إضافية 100 غرام', 25.00, '/images/items/food-add-ons-extra-angus-beef-patty-100-gram.jpg', 14, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Green Salad Side Dish', 'سلطة خضراء جانبية', 5.00, '/images/items/food-add-ons-green-salad-side-dish.jpg', 15, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Cheese Cajun Fries', 'بطاطس كاجن بالجبن', 16.00, '/images/items/food-add-ons-cheese-cajun-fries.jpg', 16, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('cce07e5d-b395-4aa3-a1fa-561c84cf71fe', 'Potato Wedges', 'بطاطس ودجز', 8.00, '/images/items/food-add-ons-potato-wedges.jpg', 17, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Caesar Sauce', 'Caesar Sauce', 4.00, '/images/items/sauce-add-ons-caesar-sauce.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Signature Sauce', 'Signature Sauce', 4.00, '/images/items/sauce-add-ons-signature-sauce.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Cheese Sauce', 'Cheese Sauce', 4.00, '/images/items/sauce-add-ons-cheese-sauce.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Spicy Cajun Sauce', 'Spicy Cajun Sauce', 4.00, '/images/items/sauce-add-ons-spicy-cajun-sauce.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Fajita White Sauce', 'Fajita White Sauce', 4.00, '/images/items/sauce-add-ons-fajita-white-sauce.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Pesto Sauce', 'Pesto Sauce', 4.00, '/images/items/sauce-add-ons-pesto-sauce.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Balsamic Sauce', 'Balsamic Sauce', 4.00, '/images/items/sauce-add-ons-balsamic-sauce.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Extra Quattro Sauce', 'Extra Quattro Sauce', 4.00, '/images/items/sauce-add-ons-extra-quattro-sauce.jpg', 8, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Extra Truffle Sauce', 'Extra Truffle Sauce', 4.00, '/images/items/sauce-add-ons-extra-truffle-sauce.jpg', 9, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Extra Italian Arrabiata Sauce', 'Extra Italian Arrabiata Sauce', 3.00, '/images/items/sauce-add-ons-extra-italian-arrabiata-sauce.jpg', 10, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('022787c5-1450-420c-a99f-d4543c828f1a', 'Extra Salsa', 'Extra Salsa', 3.00, '/images/items/sauce-add-ons-extra-salsa.jpg', 11, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Espresso', 'Espresso', 12.00, '/images/items/our-coffee-espresso.jpg', 1, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Flat White', 'Flat White', 16.00, '/images/items/our-coffee-flat-white.jpg', 2, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'White Mocha Latte', 'White Mocha Latte', 16.00, '/images/items/our-coffee-white-mocha-latte.jpg', 3, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Iced Date Cloud', 'آيسد ديت كلاود', 37.00, '/images/items/our-coffee-iced-date-cloud.jpg', 4, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Coffee Brown Caramel Latte', 'لاتيه براون كراميل', 35.00, '/images/items/our-coffee-coffee-brown-caramel-latte.jpg', 5, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Iced Tiramissu Latte', 'آيسد تيراميسو لاتيه', 35.00, '/images/items/our-coffee-iced-tiramissu-latte.jpg', 6, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Cappuccino', 'Cappuccino', 19.00, '/images/items/our-coffee-cappuccino.jpg', 7, true, true);
insert into menu_items (category_id, name_en, name_ar, price, image_url, sort_order, is_available, is_visible) values ('3d6d4a2f-f1cd-44fd-8f55-b3bbda5f8849', 'Americano Classic', 'أمريكانو كلاسيك', 16.00, '/images/items/our-coffee-americano-classic.jpg', 8, true, true);
