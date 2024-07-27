import Image from 'next/image'
import Link from 'next/link'
import React from 'react'
import hero from "../../../public/home/hero.svg";

type Props = {}

const HeroSection = (props: Props) => {
  return (
    <section className="w-full h-[60vh] relative">
      <Image src={hero} alt="Hero Background" className="object-cover w-full h-[60vh]" />
      <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
        <div className="text-center space-y-4 max-w-2xl px-4 sm:px-6">
          <h1 className="text-4xl font-bold text-white sm:text-5xl md:text-6xl">
            Protect Your Future with StarkCore
          </h1>
          <p className="text-lg text-white sm:text-xl md:text-2xl">
            Comprehensive coverage for all your insurance needs.
          </p>
          <Link
            href="#"
            className="inline-flex h-10 items-center justify-center rounded-md bg-primary px-8 text-sm font-medium text-primary-foreground shadow transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
            prefetch={false}
          >
            Get a Quote
          </Link>
        </div>
      </div>
    </section>
  )
}

export default HeroSection