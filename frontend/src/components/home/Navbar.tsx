import Link from 'next/link'
import React from 'react'
import logo from "../../../public/logo/InsurefiLogo.svg"
import Image from 'next/image'

type Props = {}

const Navbar = (props: Props) => {
  return (
    <header className="px-4 lg:px-6 h-14 flex items-center">
    <Link href="#" className="flex items-center justify-center" prefetch={false}>
      <Image src={logo} width={40} height={42} alt='logo'/>
      <span className="sr-only">InsureFI</span>
    </Link>
    <nav className="ml-auto flex gap-4 sm:gap-6">
      <Link href="#" className="text-sm font-medium hover:underline underline-offset-4" prefetch={false}>
        Products
      </Link>
      <Link href="#" className="text-sm font-medium hover:underline underline-offset-4" prefetch={false}>
        About
      </Link>
      <Link href="#" className="text-sm font-medium hover:underline underline-offset-4" prefetch={false}>
        Claims
      </Link>
      <Link href="#" className="text-sm font-medium hover:underline underline-offset-4" prefetch={false}>
        Contact
      </Link>
    </nav>
  </header>  )
}

export default Navbar


function ShieldIcon(props: React.JSX.IntrinsicAttributes & React.SVGProps<SVGSVGElement>) {
    return (
      <svg
        {...props}
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z" />
      </svg>
    )
  }
  