import React from 'react'

const HomePage: React.FC = () => {
    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
            <div className="container mx-auto px-4 py-16">
                <div className="text-center">
                    <h1 className="text-5xl font-bold text-gray-900 mb-6">
                        Node.js 開発環境
                    </h1>
                    <p className="text-xl text-gray-600 mb-8">
                        TypeScript + React + Next.js + Tailwind CSS
                    </p>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-12">
                        <div className="bg-white p-6 rounded-lg shadow-lg">
                            <h2 className="text-2xl font-semibold text-gray-800 mb-4">
                                🚀 TypeScript
                            </h2>
                            <p className="text-gray-600">
                                型安全なJavaScriptで開発効率を向上
                            </p>
                        </div>

                        <div className="bg-white p-6 rounded-lg shadow-lg">
                            <h2 className="text-2xl font-semibold text-gray-800 mb-4">
                                ⚛️ React
                            </h2>
                            <p className="text-gray-600">
                                コンポーネントベースのUI開発
                            </p>
                        </div>

                        <div className="bg-white p-6 rounded-lg shadow-lg">
                            <h2 className="text-2xl font-semibold text-gray-800 mb-4">
                                🔥 Next.js
                            </h2>
                            <p className="text-gray-600">
                                本番環境対応のReactフレームワーク
                            </p>
                        </div>
                    </div>

                    <div className="mt-12">
                        <a
                            href="/api/hello"
                            className="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors"
                        >
                            API テスト
                        </a>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default HomePage
