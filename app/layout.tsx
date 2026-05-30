import "./globals.css";
export const metadata = { title: "La Cha Cha Digital Menu", description: "Dynamic restaurant menu with admin panel" };
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="en"><head><link rel="manifest" href="/manifest.json" /></head><body>{children}</body></html>;
}
