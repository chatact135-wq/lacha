import { SignJWT, jwtVerify } from "jose";
import { cookies } from "next/headers";

const secret = new TextEncoder().encode(process.env.APP_JWT_SECRET || "dev-secret-change-me");
export type Role = "owner" | "manager" | "editor" | "viewer";

export async function createSession(payload: { id: string; username: string; role: Role }) {
  return await new SignJWT(payload)
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime("7d")
    .sign(secret);
}

export async function getSession() {
  const cookieStore = await cookies();
  const token = cookieStore.get("admin_session")?.value;
  if (!token) return null;
  try {
    const { payload } = await jwtVerify(token, secret);
    return payload as { id: string; username: string; role: Role };
  } catch {
    return null;
  }
}

export function canEdit(role?: Role) {
  return role === "owner" || role === "manager" || role === "editor";
}

export function canManageUsers(role?: Role) {
  return role === "owner";
}
