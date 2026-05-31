import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canEdit } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function GET(){ const {data} = await supabaseAdmin.from("menu_items").select("*").order("sort_order",{ascending:true}); return NextResponse.json(data || []); }
function clean(body:any){ const allowed = ["category_id","name_en","name_ar","description_en","description_ar","price","discount_percent","image_url","label","is_available","is_visible","sort_order"]; return Object.fromEntries(Object.entries(body).filter(([k])=>allowed.includes(k))); }
export async function POST(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const body=clean(await req.json()); const {data,error}=await supabaseAdmin.from("menu_items").insert(body).select("*").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
export async function PUT(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const body=await req.json(); const {id}=body; const update=clean(body); const {data,error}=await supabaseAdmin.from("menu_items").update(update).eq("id",id).select("*").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
export async function DELETE(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const {id}=await req.json(); const {error}=await supabaseAdmin.from("menu_items").delete().eq("id",id); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json({ok:true}); }
