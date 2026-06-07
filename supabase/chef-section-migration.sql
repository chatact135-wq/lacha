-- Optional migration for the dynamic Chef Selection section.
-- Run once in Supabase SQL Editor if you want to control the homepage Chef Selection from admin.
alter table settings add column if not exists chef_selection_enabled boolean default true;
alter table settings add column if not exists chef_selection_title_en text default 'Signature picks';
alter table settings add column if not exists chef_selection_title_ar text default 'اختيارات مميزة';
alter table settings add column if not exists chef_selection_subtitle_en text default 'A curated first impression that reflects the restaurant’s quality and premium taste.';
alter table settings add column if not exists chef_selection_subtitle_ar text default 'مجموعة مختارة تعكس جودة وفخامة المطعم من أول نظرة.';
alter table settings add column if not exists chef_selection_item_ids text default '';
update settings set
  chef_selection_enabled = coalesce(chef_selection_enabled, true),
  chef_selection_title_en = coalesce(chef_selection_title_en, 'Signature picks'),
  chef_selection_title_ar = coalesce(chef_selection_title_ar, 'اختيارات مميزة'),
  chef_selection_subtitle_en = coalesce(chef_selection_subtitle_en, 'A curated first impression that reflects the restaurant’s quality and premium taste.'),
  chef_selection_subtitle_ar = coalesce(chef_selection_subtitle_ar, 'مجموعة مختارة تعكس جودة وفخامة المطعم من أول نظرة.'),
  chef_selection_item_ids = coalesce(chef_selection_item_ids, '')
where id = 1;
