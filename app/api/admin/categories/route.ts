import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canEdit } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function GET(){ const {data} = await supabaseAdmin.from("categories").select("*").order("sort_order",{ascending:true}); return NextResponse.json(data || []); }
export async function POST(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const body=await req.json(); const {data,error}=await supabaseAdmin.from("categories").insert(body).select("*").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
export async function PUT(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const body=await req.json(); const {id,...update}=body; const {data,error}=await supabaseAdmin.from("categories").update(update).eq("id",id).select("*").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
export async function DELETE(req:Request){ const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const {id}=await req.json(); const {error}=await supabaseAdmin.from("categories").delete().eq("id",id); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json({ok:true}); }
