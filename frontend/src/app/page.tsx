import AboutSection from '@/components/home/AboutSection'
import Faq from '@/components/home/Faq'
import Footer from '@/components/home/Footer'
import HeroSection from '@/components/home/HeroSection'
import Navbar from '@/components/home/Navbar'
import OurOffersSection from '@/components/home/OurOffersSection'
import ReviewSection from '@/components/home/ReviewSection'
import React from 'react'

type Props = {}

const Page = (props: Props) => {
  return (
    <div className="flex flex-col min-h-[100dvh]">
      <HeroSection />
      <AboutSection />
      <OurOffersSection />
      <ReviewSection />
      <Faq />
      <Footer />
    </div>
  )
}

export default Page