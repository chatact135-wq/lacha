import { NextResponse } from "next/server";
import bcrypt from "bcryptjs";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canManageUsers } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function GET(){ const session=await getSession(); if(!canManageUsers(session?.role as any)) return NextResponse.json([]); const {data}=await supabaseAdmin.from("app_users").select("id,username,role,is_active,created_at").order("created_at",{ascending:false}); return NextResponse.json(data || []); }
export async function POST(req:Request){ const session=await getSession(); if(!canManageUsers(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401}); const {username,password,role}=await req.json(); if(!username || !password) return NextResponse.json({error:"Username and password are required"},{status:400}); const password_hash=await bcrypt.hash(password,10); const {data,error}=await supabaseAdmin.from("app_users").insert({username,password_hash,role:role||"editor",is_active:true}).select("id,username,role,is_active").single(); if(error) return NextResponse.json({error:error.message},{status:400}); return NextResponse.json(data); }
