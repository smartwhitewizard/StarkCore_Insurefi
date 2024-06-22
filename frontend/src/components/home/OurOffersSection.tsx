import React from 'react'

type Props = {}

const OurOffersSection = (props: Props) => {
  return (
      <section className="w-full py-12 md:py-24 lg:py-32 bg-[url('/home/hero.svg')] bg-cover h-auto">
    <div className="container px-4 md:px-6">
      <div className="flex flex-col items-center justify-center space-y-4 text-center">
        <div className="space-y-2">
          <div className="inline-block rounded-lg bg-neutral-200 px-3 py-1 text-sm">Our Insurance Products</div>
          <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl">
            Comprehensive Coverage for Your Needs
          </h2>
          <p className="max-w-[900px] text-muted-foreground md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
            StarkCore offers a wide range of insurance products to protect you, your family, and your assets.
            From life insurance to home and auto coverage, we've got you covered.
          </p>
        </div>
      </div>
      <div className="mx-auto grid max-w-5xl items-center gap-6 py-12 lg:grid-cols-3 lg:gap-12">
        <div className="flex flex-col items-center justify-center space-y-4">
          <LifeBuoyIcon className="h-12 w-12 text-primary" />
          <h3 className="text-xl font-bold">Life Insurance</h3>
          <p className="text-muted-foreground">
            Protect your loved ones with our comprehensive life insurance plans.
          </p>
        </div>
        <div className="flex flex-col items-center justify-center space-y-4">
          <HomeIcon className="h-12 w-12 text-primary" />
          <h3 className="text-xl font-bold">Home Insurance</h3>
          <p className="text-muted-foreground">
            Safeguard your most valuable asset with our home insurance coverage.
          </p>
        </div>
        <div className="flex flex-col items-center justify-center space-y-4">
          <CarIcon className="h-12 w-12 text-primary" />
          <h3 className="text-xl font-bold">Auto Insurance</h3>
          <p className="text-muted-foreground">
            Enjoy peace of mind on the road with our comprehensive auto insurance plans.
          </p>
        </div>
      </div>
    </div>
  </section>
  )
}

export default OurOffersSection

function CarIcon(props: React.JSX.IntrinsicAttributes & React.SVGProps<SVGSVGElement>) {
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
        <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2" />
        <circle cx="7" cy="17" r="2" />
        <path d="M9 17h6" />
        <circle cx="17" cy="17" r="2" />
      </svg>
    )
  }
  
  function HomeIcon(props: React.JSX.IntrinsicAttributes & React.SVGProps<SVGSVGElement>) {
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
        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
        <polyline points="9 22 9 12 15 12 15 22" />
      </svg>
    )
  }
  
  
  function LifeBuoyIcon(props: React.JSX.IntrinsicAttributes & React.SVGProps<SVGSVGElement>) {
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
        <circle cx="12" cy="12" r="10" />
        <path d="m4.93 4.93 4.24 4.24" />
        <path d="m14.83 9.17 4.24-4.24" />
        <path d="m14.83 14.83 4.24 4.24" />
        <path d="m9.17 14.83-4.24 4.24" />
        <circle cx="12" cy="12" r="4" />
      </svg>
    )
  }
  