import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canEdit } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function POST(req:Request){
  const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401});
  const { itemIds, discount_percent } = await req.json();
  const ids = Array.isArray(itemIds) ? itemIds : [];
  const discount = Math.max(0, Math.min(100, Number(discount_percent || 0)));
  if(!ids.length) return NextResponse.json({error:"No items selected"},{status:400});
  const {data,error}=await supabaseAdmin.from("menu_items").update({ discount_percent: discount }).in("id", ids).select("id,name_en,discount_percent");
  if(error) return NextResponse.json({error:error.message},{status:400});
  return NextResponse.json({ok:true, updated:data?.length || 0});
}
