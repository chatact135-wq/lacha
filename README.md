
# La Cha Cha Digital Menu App

Professional bilingual restaurant menu app with a dynamic admin panel.

## Corrected data included
This package includes corrected seed data extracted from the provided menu screenshots:
- Arabic + English categories
- Arabic + English item names
- AED prices
- Cropped food images saved in `public/images/items/`
- Review file: `extracted-menu-review.csv`
- Supabase seed: `supabase/schema.sql`

## Default admin login
- Username: `admin`
- Password: `123`

Change this after first login before publishing publicly.

## Admin can change
Restaurant name, logo, opening hours, phone, WhatsApp, address, Google Maps link, social media, delivery links, colors, categories, menu items, prices, images, sold-out status, visibility, users and roles.

## Deploy summary
1. Create Supabase project.
2. Open Supabase SQL Editor and run `supabase/schema.sql`.
3. Upload this project to GitHub.
4. Connect GitHub to Vercel.
5. Add environment variables from `.env.example`.
6. Deploy.
