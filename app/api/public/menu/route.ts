import { NextResponse } from "next/server";
import { supabaseAdmin } from "../../../../lib/supabase";

export async function GET() {
  const [{ data: settings }, { data: categories }, { data: items }, { data: deliveryLinks }] = await Promise.all([
    supabaseAdmin.from("settings").select("*").eq("id", 1).single(),
    supabaseAdmin.from("categories").select("*").eq("is_visible", true).order("sort_order"),
    supabaseAdmin.from("menu_items").select("*").eq("is_visible", true).order("sort_order"),
    supabaseAdmin.from("delivery_links").select("*").eq("is_visible", true).order("sort_order")
  ]);
  return NextResponse.json({ settings, categories: categories || [], items: items || [], deliveryLinks: deliveryLinks || [] });
}
