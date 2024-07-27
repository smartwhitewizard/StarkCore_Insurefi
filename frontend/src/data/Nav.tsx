import { FaCloud, FaDatabase, FaHome, FaList } from "react-icons/fa";
import { BsFillPeopleFill } from "react-icons/bs";

import { ReactNode } from "react";

type SideTypes = {
  href: string;
  icon: ReactNode;
  name: string;
};

export const SideLinks: SideTypes[] = [
  {
    href: "/dashboard",
    icon: <FaHome />,
    name: "Dashboard"
  },
  {
    href: "/overview",
    icon: <FaList />,
     name: "Subscription"
  },
  {
    href: "/packages",
    icon: <FaCloud />,
     name: "Claims"
  },
  {
    href: "/billing",
    icon: <FaDatabase />,
     name: "Billing"
  },
  {
    href: "/governance",
    icon: <BsFillPeopleFill />,
    name: "Governance"
  },
];
