import "./globals.css";

export const metadata = {
  title: "La Cha Cha | Luxury Digital Menu",
  description: "A premium animated restaurant menu with admin control panel, discounts, WhatsApp ordering, and luxury slideshow design.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#120508" />
      </head>
      <body>{children}</body>
    </html>
  );
}
