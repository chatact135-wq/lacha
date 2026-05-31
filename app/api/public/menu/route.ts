import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function GET(){
  const [settings, categories, items, deliveryLinks] = await Promise.all([
    supabaseAdmin.from("settings").select("*").eq("id",1).maybeSingle(),
    supabaseAdmin.from("categories").select("*").eq("is_visible",true).order("sort_order",{ascending:true}),
    supabaseAdmin.from("menu_items").select("*").eq("is_visible",true).order("sort_order",{ascending:true}),
    supabaseAdmin.from("delivery_links").select("*").eq("is_visible",true).order("sort_order",{ascending:true})
  ]);
  return NextResponse.json({ settings: settings.data || {}, categories: categories.data || [], items: items.data || [], deliveryLinks: deliveryLinks.data || [] });
}
