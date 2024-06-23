import { FaCloud, FaDatabase, FaHome, FaList } from "react-icons/fa";
import { BsFillPeopleFill } from "react-icons/bs";

import { ReactNode } from "react";

type SideTypes = {
  href: string;
  icon: ReactNode;
};

export const SideLinks: SideTypes[] = [
  {
    href: "/dashboard",
    icon: <FaHome />,
  },
  {
    href: "/overview",
    icon: <FaList />,
  },
  {
    href: "/packages",
    icon: <FaCloud />,
  },
  {
    href: "/billing",
    icon: <FaDatabase />,
  },
  {
    href: "/governance",
    icon: <BsFillPeopleFill />
  },
];
