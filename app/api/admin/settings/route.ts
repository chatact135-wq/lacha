import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canEdit } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function GET(){ const {data} = await supabaseAdmin.from("settings").select("*").eq("id",1).maybeSingle(); return NextResponse.json(data || {}); }
export async function PUT(req:Request){ const session = await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const body = await req.json(); const {data,error} = await supabaseAdmin.from("settings").upsert({ ...body, id:1, updated_at:new Date().toISOString() }).select("*").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
