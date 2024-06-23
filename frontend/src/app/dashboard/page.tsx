import Navbar from '@/components/home/Navbar'
import Card from '@/components/shared/Card'
import Card2 from '@/components/shared/Card2'
import Card3 from '@/components/shared/Card3'
import Sidebar from '@/components/shared/Sidebar'
import Statistics from '@/components/shared/Statistics'
import React from 'react'

type Props = {}

const Home = (props: Props) => {
  return (
    <div className='px-6 w-full border-t-2 border-t-gray-100 my-4'>
      <div className='flex'>
        <Sidebar />

        <div className='ml-6 mt-6'>
          <div className='flex w-full gap-6'>
            <div className='w-1/3'>
              <Card
                title="Auto Insuarance"
                details="Enjoy peace of mind on the road with our comprehensive auto insurance plans."
              />
            </div>
            <div className='w-1/3'>
              <Card
                title="Property Insurance"
                details="Safeguard your most valuable asset with our property insurance coverage."
              />
            </div>
            <div className='w-1/3'>
              <Card 
                title="Home Insurance" 
                details="Protect your home and personal belongings with our comprehensive home insurance plans." 
              />
            </div>
            
          </div>

          <div className='flex my-12 gap-6'>
            <div className='w-2/3'>
              <Card2
                title="StarkCore"
                details="Here to provide comprehensive coverage for all your insurance needs."
                imageUrl="https://images.pexels.com/photos/1435752/pexels-photo-1435752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
              />
            </div>
            <div className='w-1/3'>
              <Card 
                title="Governance"
                details="View all active proposals and contribute to the DAO"  
              />
            </div>
            
          </div>

          <div className='mb-6 flex w-full gap-6'>
            
            <div className='w-2/3'>
                <Statistics />
            </div>
          
            <div className='w-1/3'>
              <Card3 />
            </div>

          </div>
          
        </div>
      </div>
    </div>
  )
}

export default Home