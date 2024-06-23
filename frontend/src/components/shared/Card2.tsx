import React from 'react';
import { FaArrowRight } from 'react-icons/fa';

const Card2 = ({ title, details, imageUrl }:any) => {
  return (
    <div className="relative shadow-lg overflow-hidden rounded-lg">
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: `url(${imageUrl})`, filter: 'brightness(0.75) contrast(1.2)' }}
      ></div>
      <div className="relative bg-black bg-opacity-50 p-6">
        <h2 className="text-xl font-semibold text-white">{title}</h2>
      </div>
      <div className="relative p-6 bg-black bg-opacity-50">
        <p className="text-gray-300">{details}</p>
      </div>
      <div className="relative p-6 bg-black bg-opacity-50 flex">
        <button className="border-blue-500 border text-blue-500 px-4 py-2 rounded hover:bg-blue-600 hover:text-white flex items-center gap-3">
          Get Started
          <span>
            <FaArrowRight className="text-sm" />
          </span>
        </button>
      </div>
    </div>
  );
};

export default Card2;
