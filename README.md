# La Cha Cha Luxury Digital Menu

Ready for Netlify + Supabase.

## What is included
- Luxury restaurant homepage design.
- Animated hero slideshow with high-quality premium food banners.
- Smart category sorting: main food first, then desserts, coffee, beverages, sauces, and add-ons last.
- Menu cards with discount display.
- WhatsApp ordering.
- Admin panel for settings, logo/banner upload, categories, items, discount, and users.
- Smart image upload normalization for item photos.

## Netlify build settings
Base directory: blank
Package directory: Not set
Build command:

```bash
npm install --legacy-peer-deps && npm run build
```

Publish directory:

```bash
.next
```

## Required environment variables
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY
- APP_JWT_SECRET
- NODE_VERSION = 20
- NPM_FLAGS = --legacy-peer-deps

## Supabase
Run the SQL files in the `supabase` folder if this is a new database.
Create public storage bucket:

```text
menu-images
```

## Admin
/admin

Default test login:

```text
admin
123
```

Change password before public launch.
