import Link from 'next/link'
import React from 'react'
import logo from "../../../public/logo/InsurefiLogo.svg"
import Image from 'next/image'
import { Button } from '../ui/button'

type Props = {}

const Navbar = (props: Props) => {
  return (
    <header className="px-4 lg:px-6 h-14 flex justify-between items-center">

      <Link href="/" className="flex items-center justify-center" prefetch={false}>
        <Image src={logo} width={40} height={42} alt='logo' />
        <h2 className='font-bold text-xl'>StarkCore</h2>
      </Link>
      <nav className="flex gap-4 sm:gap-6">
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
      <Button>
        Connect Wallet
      </Button>
    </header>)
}

export default Navbar

