-- Run this once in Supabase SQL Editor if your database was already created before this update.
alter table settings add column if not exists hero_image_url text;
alter table menu_items add column if not exists discount_percent numeric(5,2) default 0;
update menu_items set discount_percent = 0 where discount_percent is null;
