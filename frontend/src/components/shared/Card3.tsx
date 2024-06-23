import { ActivityIcon, CreditCardIcon, DollarSignIcon, UsersIcon } from 'lucide-react'
import React from 'react'

const Card3 = () => {
    return (
        <div>
        <div className="flex justify-between w-full gap-3 mb-14 mt-1">
            <div className="py-4 px-2 flex flex-col w-1/2 border border-gray-200 shadow-md">
                
                <div className="text-center flex flex-col items-center mb-14">
                    <h4>Total Revenue</h4>
                    <DollarSignIcon className="h-5 w-5 text-[#287D00]" />
                </div>
                   
                <div className='text-start'>
                    <div className="text-3xl font-bold">$45,231.89</div>
                    <p className="text-sm text-muted-foreground">+20.1% from last month</p>    
                </div>
                </div>
                
                <div className="py-4 px-2  flex flex-col w-1/2 border shadow-md border-gray-200">
                
                <div className="text-center flex flex-col items-center mb-14">
                    <h4>Total Claims</h4>
                    <CreditCardIcon className="h-5 w-5 text-[#ff7327]" />
                </div>
                   
                <div className='text-start'>
                    <div className="text-3xl font-bold">$10,541.29</div>
                    <p className="text-sm text-muted-foreground">+19% from last month</p>    
                </div>
            </div>

           </div>
            
        <div className="flex justify-between w-full gap-3">

           <div className="py-4 px-2 flex flex-col w-1/2 border shadow-md border-gray-200 ">
                
                <div className="text-center flex flex-col items-center mb-14">
                    <h4>New Subscriptions</h4>
                    <UsersIcon className="h-5 w-5 text-blue-500 " />
                </div>
                   
                <div className='text-start'>
                    <div className="text-3xl font-bold">+2,350</div>
                    <p className="text-sm text-muted-foreground">+180.1% from last month</p>    
                </div>
            </div>
     
           <div className="py-4 px-2  flex flex-col w-1/2 border shadow-md border-gray-200">
                
                <div className="text-center flex flex-col items-center mb-14">
                    <h4>Active Users</h4>
                    <ActivityIcon className="h-5 w-5 text-[#FF0B0B]" />
                </div>
                   
                <div className='text-start'>
                    <div className="text-3xl font-bold">+573</div>
                    <p className="text-sm text-muted-foreground">+201 since last hour</p>    
                </div>
            </div>
        </div>

        </div>
       
   )
}

export default Card3