import { createClient } from "@supabase/supabase-js";

// Fallback values allow Netlify/Next.js to complete the build step.
// In production, Netlify environment variables must provide the real values.
const url = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://placeholder.supabase.co";
const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "placeholder-anon-key";
const service = process.env.SUPABASE_SERVICE_ROLE_KEY || anon;

export const supabasePublic = createClient(url, anon, {
  auth: { persistSession: false }
});

export const supabaseAdmin = createClient(url, service, {
  auth: { persistSession: false }
});
