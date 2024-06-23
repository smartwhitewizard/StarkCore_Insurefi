import React from 'react'
import { FaArrowRight } from 'react-icons/fa'

const Card = ({title, details}:any) => {
  return (
      <div>
        <div className="bg-gray-100 shadow-sm overflow-hidden hover:scale-105 transition-transform transform rounded-lg">
            <div className="p-6">
                <h2 className="text-xl font-semibold text-black">{title}</h2>
            </div>
            <div className="p-6">
                  <p className="text-gray-700">{ details}</p>
            </div>
            <div className="p-6 flex">
                <button className="border-blue-500 border text-blue-500 px-4 py-2 rounded hover:bg-blue-600 hover:text-white flex items-center gap-3">
                      Get Started
                      <span>
                          <FaArrowRight className='text-sm'/>
                      </span>
                </button>
            </div>
        </div>
    </div>
  )
}

export default Card