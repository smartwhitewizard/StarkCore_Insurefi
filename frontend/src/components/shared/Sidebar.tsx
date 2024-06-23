import { SideLinks } from "@/data/Nav";
import Link from "next/link";
import React from "react";

const Sidebar = () => {
  return (
      <div className="border-r-2 border-r-gray-100 min-h-svh">
        <nav className="w-1/6 pt-8">
            <ul >
                {SideLinks.map((link, index) => (
                <li key={index} className="text-xl font-medium py-3 pl-2 pr-8">
                    <Link href={link.href} className="cursor-pointer">
                    <div>{link.icon}</div>
                    </Link>
                </li>
                ))}
            </ul>
        </nav>
   </div>
  );
};

export default Sidebar;
