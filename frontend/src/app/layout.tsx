import type { Metadata } from "next";
import "@/styles/globals.css"
import Script from "next/script";
import { Poppins as FontSans } from "next/font/google"
import { cn } from "@/lib/utils"
import { StarknetProvider } from "@/provider/starknet-provider";
import Navbar from "@/components/home/Navbar";

const fontSans = FontSans({
  subsets: ["latin"],
  weight: ["100", "200", "300", "400", "500", "600", "700", "800", "900"],
  variable: "--font-sans",
})

export const metadata: Metadata = {
  title: "StarkCore",
  description: "A decentralized Insurefi application on StarkNet tailored to give secured and save insuarance participation",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={cn(
        "min-h-screen w-full font-sans antialiased bg-white",
        fontSans.variable
      )}>
        <StarknetProvider>
          <Navbar/>
          {children}
        </StarknetProvider>
      </body>
    </html>
  );
}
