"use client";

import React from 'react'
import { GraphIcon } from '../../../public/icons/grapht';
import SimpleLineChat from './SimpleLineChart';

const Statistics = () => {
    return (
        <div>
            <div className="">
                <div className="flex flex-col p-8 col-span-2 rounded-lg bg-gray-100 h-auto shadow-md">
                    <h3 className='text-xl font-semibold text-black'>Indexes</h3>
                    <div className="flex gap-20  px-10 py-4">
                        <div className="flex gap-1">
                            <span className="text-[#FF0B0B]">
                                <GraphIcon />
                            </span>
                            <span className="text-base">Claims</span>
                        </div>
                        <div className="flex gap-1">
                            <span className="text-[16.87px] text-[#287D00]">
                                <GraphIcon />
                            </span>
                            <span className="text-base">Policies</span>
                        </div>
                    </div>
                    <SimpleLineChat />
                </div>

            </div>
        </div>
    );
};

export default Statistics