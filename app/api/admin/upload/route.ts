import { NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase";
import { getSession, canEdit } from "@/lib/auth";
export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export async function POST(req:Request){
  const session=await getSession(); if(!canEdit(session?.role as any)) return NextResponse.json({error:"Unauthorized"},{status:401});
  const form = await req.formData(); const file = form.get("file") as File | null; if(!file) return NextResponse.json({error:"No file"},{status:400});
  const ext = file.name.split('.').pop() || 'jpg'; const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
  const bytes = await file.arrayBuffer();
  const { error } = await supabaseAdmin.storage.from("menu-images").upload(path, bytes, { contentType:file.type || "image/jpeg", upsert:false });
  if(error) return NextResponse.json({error:`Upload failed: ${error.message}. Make sure Supabase Storage bucket menu-images exists and is public.`},{status:400});
  const { data } = supabaseAdmin.storage.from("menu-images").getPublicUrl(path);
  return NextResponse.json({url:data.publicUrl});
}
