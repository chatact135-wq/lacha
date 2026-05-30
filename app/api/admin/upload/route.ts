export const dynamic = "force-dynamic";
export const runtime = "nodejs";
import { NextResponse } from "next/server";
import { getSession, canEdit } from "../../../../lib/auth";
import { supabaseAdmin } from "../../../../lib/supabase";

export async function POST(req: Request) {
  const session = await getSession();
  if (!canEdit(session?.role)) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  const form = await req.formData();
  const file = form.get("file") as File | null;
  if (!file) return NextResponse.json({ error: "No file" }, { status: 400 });
  const ext = file.name.split(".").pop() || "jpg";
  const path = `menu/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
  const arrayBuffer = await file.arrayBuffer();
  const { error } = await supabaseAdmin.storage.from("menu-images").upload(path, Buffer.from(arrayBuffer), { contentType: file.type, upsert: false });
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  const { data } = supabaseAdmin.storage.from("menu-images").getPublicUrl(path);
  return NextResponse.json({ url: data.publicUrl });
}
